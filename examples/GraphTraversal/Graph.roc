## The Graph interface represents a graph using an adjacency list and exposes
## functions for working with graphs, such as creating one from a list and
## performing a depth-first or breadth-first search.
interface Graph
    exposes [
        Graph,
        fromList,
        dfs,
        bfs,
    ]
    imports [
        Dict,
    ]

## Graph type representing a graph as a dictionary of adjacency lists
## where each key is a vertex and each value is a list of its adjacent vertices.
Graph a := Dict a (List a) | a has Eq

## Create a Graph from an adjacency list.
fromList : List (a, List a) -> Graph a
fromList = \adjacencyList ->
    emptyDict = Dict.withCapacity (List.len adjacencyList)

    update = \dict, (vertex, edges) ->
        Dict.insert dict vertex edges

    List.walk adjacencyList emptyDict update
    |> @Graph

## Perform a depth-first search on a graph to find a target vertex.
##
## - `isTarget` : A function that returns true if a vertex is the target.
## - `root`     : The starting vertex for the search.
## - `graph`    : The graph to perform the search on.
dfs : (a -> Bool), a, Graph a -> Result a [NotFound]
dfs = \isTarget, root, @Graph graph ->
    dfsHelper isTarget [root] [] graph

# A helper function for performing the depth-first search.
#
# `isTarget` : A function that returns true if a vertex is the target.
# `stack`    : A list of vertices to visit.
# `visited`  : A list of visited vertices.
# `graph`    : The graph to perform the search on.
dfsHelper : (a -> Bool), List a, List a, Dict a (List a) -> Result a [NotFound]
dfsHelper = \isTarget, stack, visited, graph ->
    when stack is
        [] ->
            Err NotFound

        [.., current] ->
            rest = List.dropLast stack

            if isTarget current then
                Ok current
            else if List.contains visited current then
                dfsHelper isTarget rest visited graph
            else
                newVisited = List.prepend visited current

                when Dict.get graph current is
                    Ok neighbors ->
                        # newly explored nodes are added to LIFO stack
                        newStack = List.concat neighbors rest

                        dfsHelper isTarget newStack newVisited graph

                    Err KeyNotFound ->
                        dfsHelper isTarget rest newVisited graph

## Perform a breadth-first search on a graph to find a target vertex.
##
## - `isTarget` : A function that returns true if a vertex is the target.
## - `root`     : The starting vertex for the search.
## - `graph`    : The graph to perform the search on.
bfs : (a -> Bool), a, Graph a -> Result a [NotFound]
bfs = \isTarget, root, @Graph graph ->
    bfsHelper isTarget [root] [] graph

# A helper function for performing the breadth-first search.
#
# `isTarget` : A function that returns true if a vertex is the target.
# `queue`    : A list of vertices to visit.
# `visited`  : A list of visited vertices.
# `graph`    : The graph to perform the search on.
bfsHelper : (a -> Bool), List a, List a, Dict a (List a) -> Result a [NotFound]
bfsHelper = \isTarget, queue, visited, graph ->
    when queue is
        [] ->
            Err NotFound

        [current, ..] ->
            rest = List.dropFirst queue

            if isTarget current then
                Ok current
            else if List.contains visited current then
                bfsHelper isTarget rest visited graph
            else
                newVisited = List.append visited current

                when Dict.get graph current is
                    Ok neighbors ->
                        # newly explored nodes are added to the FIFO queue
                        newQueue = List.concat rest neighbors

                        bfsHelper isTarget newQueue newVisited graph

                    Err KeyNotFound ->
                        bfsHelper isTarget rest newVisited graph

# Some helpers for testing
testGraph =
    [
        ("A", ["B", "C"]),
        ("B", ["D", "E"]),
        ("C", []),
        ("D", []),
        ("E", ["F"]),
        ("F", []),
    ]
    |> fromList

# Test using depth-first search.
expect
    actual = dfs (\v -> v == "F") "A" testGraph
    expected = Ok "F"

    actual == expected

## Test and breadth-first search.
expect
    actual = bfs (\v -> v == "F") "A" testGraph
    expected = Ok "F"

    actual == expected

# Test node not present depth-first search
expect
    actual = dfs (\v -> v == "X") "A" testGraph
    expected = Err NotFound

    actual == expected

# Test node not present breadth-first search
expect
    actual = dfs (\v -> v == "X") "A" testGraph
    expected = Err NotFound

    actual == expected
