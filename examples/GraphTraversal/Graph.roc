## The Graph module represents a [graph](https://en.wikipedia.org/wiki/Graph_(discrete_mathematics))
## using an [adjacency list](https://en.wikipedia.org/wiki/Adjacency_list)
## and exposes functions for working with graphs, such as creating one from a list and
## performing a depth-first or breadth-first search.
module [
    Graph,
    from_list,
    from_dict,
    dfs,
    bfs,
]

## Graph type representing a graph as a dictionary of adjacency lists,
## where each key is a vertex and each value is a list of its adjacent vertices.
Graph a := Dict a (List a) where a implements Eq

## Create a Graph from an adjacency list.
from_list : List (a, List a) -> Graph a
from_list = |adjacency_list|
    empty_dict = Dict.with_capacity(List.len(adjacency_list))

    update = |dict, (vertex, edges)|
        Dict.insert(dict, vertex, edges)

    @Graph(List.walk(adjacency_list, empty_dict, update))

## Create a Graph from an adjacency list.
from_dict : Dict a (List a) -> Graph a
from_dict = @Graph

## Perform a depth-first search on a graph to find a target vertex.
## [Algorithm animation](https://en.wikipedia.org/wiki/Depth-first_search#/media/File:Depth-First-Search.gif)
##
## - `is_target` : A function that returns true if a vertex is the target.
## - `root`     : The starting vertex for the search.
## - `graph`    : The graph to perform the search on.
dfs : (a -> Bool), a, Graph a -> Result a [NotFound]
dfs = |is_target, root, @Graph(graph)|
    dfs_helper(is_target, [root], Set.empty({}), graph)

# A helper function for performing the depth-first search.
#
# `is_target` : A function that returns true if a vertex is the target.
# `stack`    : A List of vertices to visit.
# `visited`  : A Set of visited vertices.
# `graph`    : The graph to perform the search on.
dfs_helper : (a -> Bool), List a, Set a, Dict a (List a) -> Result a [NotFound]
dfs_helper = |is_target, stack, visited, graph|
    when stack is
        [] ->
            Err(NotFound)

        [.., current] ->
            rest = List.drop_last(stack, 1)

            if is_target(current) then
                Ok(current)
            else if Set.contains(visited, current) then
                dfs_helper(is_target, rest, visited, graph)
            else
                new_visited = Set.insert(visited, current)

                when Dict.get(graph, current) is
                    Ok(neighbors) ->
                        # filter out all visited neighbors
                        filtered =
                            neighbors
                            |> List.keep_if(|n| !(Set.contains(new_visited, n)))
                            |> List.reverse

                        # newly explored nodes are added to LIFO stack
                        new_stack = List.concat(rest, filtered)

                        dfs_helper(is_target, new_stack, new_visited, graph)

                    Err(KeyNotFound) ->
                        dfs_helper(is_target, rest, new_visited, graph)

## Perform a breadth-first search on a graph to find a target vertex.
## [Algorithm animation](https://en.wikipedia.org/wiki/Breadth-first_search#/media/File:Animated_BFS.gif)
##
## - `is_target` : A function that returns true if a vertex is the target.
## - `root`     : The starting vertex for the search.
## - `graph`    : The graph to perform the search on.
bfs : (a -> Bool), a, Graph a -> Result a [NotFound]
bfs = |is_target, root, @Graph(graph)|
    bfs_helper(is_target, [root], Set.single(root), graph)

# A helper function for performing the breadth-first search.
#
# `is_target` : A function that returns true if a vertex is the target.
# `queue`    : A List of vertices to visit.
# `seen`  : A Set of all seen vertices.
# `graph`    : The graph to perform the search on.
bfs_helper : (a -> Bool), List a, Set a, Dict a (List a) -> Result a [NotFound]
bfs_helper = |is_target, queue, seen, graph|
    when queue is
        [] ->
            Err(NotFound)

        [current, ..] ->
            rest = List.drop_first(queue, 1)

            if is_target(current) then
                Ok(current)
            else
                when Dict.get(graph, current) is
                    Ok(neighbors) ->
                        # filter out all seen neighbors
                        filtered = List.keep_if(neighbors, |n| !(Set.contains(seen, n)))

                        # newly explored nodes are added to the FIFO queue
                        new_queue = List.concat(rest, filtered)

                        # the new nodes are also added to the seen set
                        new_seen = List.walk(filtered, seen, Set.insert)

                        bfs_helper(is_target, new_queue, new_seen, graph)

                    Err(KeyNotFound) ->
                        bfs_helper(is_target, rest, seen, graph)

# Test DFS with multiple paths
expect
    actual = dfs(|v| Str.starts_with(v, "C"), "A", test_graph_multipath)
    expected = Ok("Ccorrect")

    actual == expected

# Test BFS with multiple paths
expect
    actual = bfs(|v| Str.starts_with(v, "C"), "A", test_graph_multipath)
    expected = Ok("Ccorrect")

    actual == expected

# Test DFS
expect
    actual = dfs(|v| Str.starts_with(v, "F"), "A", test_graph_small)
    expected = Ok("F-DFS")

    actual == expected

## Test BFS
expect
    actual = bfs(|v| Str.starts_with(v, "F"), "A", test_graph_small)
    expected = Ok("F-BFS")

    actual == expected

# Test NotFound DFS
expect
    actual = dfs(|v| v == "not a node", "A", test_graph_small)
    expected = Err(NotFound)

    actual == expected

# Test NotFound BFS
expect
    actual = dfs(|v| v == "not a node", "A", test_graph_small)
    expected = Err(NotFound)

    actual == expected

# Test DFS large
expect
    actual = dfs(|v| v == "AE", "A", test_graph_large)
    expected = Ok("AE")

    actual == expected

## Test BFS large
expect
    actual = bfs(|v| v == "AE", "A", test_graph_large)
    expected = Ok("AE")

    actual == expected

# Some helpers for testing
test_graph_small =
    [
        ("A", ["B", "C", "F-BFS"]),
        ("B", ["D", "E"]),
        ("C", []),
        ("D", []),
        ("E", ["F-DFS"]),
        ("F-BFS", []),
        ("F-DFS", []),
    ]
    |> from_list

test_graph_large =
    [
        ("A", ["B", "C", "D"]),
        ("B", ["E", "F", "G"]),
        ("C", ["H", "I", "J"]),
        ("D", ["K", "L", "M"]),
        ("E", ["N", "O"]),
        ("F", ["P", "Q"]),
        ("G", ["R", "S"]),
        ("H", ["T", "U"]),
        ("I", ["V", "W"]),
        ("J", ["X", "Y"]),
        ("K", ["Z", "AA"]),
        ("L", ["AB", "AC"]),
        ("M", ["AD", "AE"]),
        ("N", []),
        ("O", []),
        ("P", []),
        ("Q", []),
        ("R", []),
        ("S", []),
        ("T", []),
        ("U", []),
        ("V", []),
        ("W", []),
        ("X", []),
        ("Y", []),
        ("Z", []),
        ("AA", []),
        ("AB", []),
        ("AC", []),
        ("AD", []),
        ("AE", []),
    ]
    |> from_list

test_graph_multipath =
    [
        ("A", ["B", "Ccorrect"]),
        ("B", ["Ccorrect", "Cwrong"]),
        ("Ccorrect", []),
        ("Cwrong", []),
    ]
    |> from_list
