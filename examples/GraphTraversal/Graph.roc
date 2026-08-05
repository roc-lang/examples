## The Graph module represents a [graph](https://en.wikipedia.org/wiki/Graph_(discrete_mathematics))
## using an [adjacency list](https://en.wikipedia.org/wiki/Adjacency_list)
## and exposes functions for working with graphs, such as creating one from a list and
## performing a depth-first or breadth-first search.

## Graph type representing a graph as a dictionary of adjacency lists,
## where each key is a vertex and each value is a list of its adjacent vertices.
Graph(a) :: Dict(a, List(a)).{
	is_eq : _

	## Create a Graph from an adjacency list.
	from_list : List((a, List(a))) -> Graph(a)
		where [a.is_eq : a, a -> Bool, a.to_hash : a, Hasher -> Hasher]
	from_list = |adjacency_list| {
		from_dict(Dict.from_list(adjacency_list))
	}

	## Create a Graph from an adjacency dict.
	from_dict : Dict(a, List(a)) -> Graph(a)
		where [a.is_eq : a, a -> Bool, a.to_hash : a, Hasher -> Hasher]
	from_dict = |dict| Graph.(dict)

	## Perform a depth-first search on a graph to find a target vertex.
	## [Algorithm animation](https://en.wikipedia.org/wiki/Depth-first_search#/media/File:Depth-First-Search.gif)
	##
	## - `graph`     : The graph to perform the search on.
	## - `is_target` : A function that returns true if a vertex is the target.
	## - `root`      : The starting vertex for the search.
	dfs : Graph(a), (a -> Bool), a -> Try(a, [NotFound])
		where [a.is_eq : a, a -> Bool, a.to_hash : a, Hasher -> Hasher]
	dfs = |Graph.(graph), is_target, root| {
		dfs_helper(graph, is_target, [root], Set.empty())
	}

	## Perform a breadth-first search on a graph to find a target vertex.
	## [Algorithm animation](https://en.wikipedia.org/wiki/Breadth-first_search#/media/File:Animated_BFS.gif)
	##
	## - `graph`     : The graph to perform the search on.
	## - `is_target` : A function that returns true if a vertex is the target.
	## - `root`      : The starting vertex for the search.
	bfs : Graph(a), (a -> Bool), a -> Try(a, [NotFound])
		where [a.is_eq : a, a -> Bool, a.to_hash : a, Hasher -> Hasher]
	bfs = |Graph.(graph), is_target, root| {
		bfs_helper(graph, is_target, [root], Set.single(root))
	}
}

# A helper function for performing the depth-first search.
#
# `is_target` : A function that returns true if a vertex is the target.
# `stack`     : A List of vertices to visit.
# `visited`   : A Set of visited vertices.
# `graph`     : The graph to perform the search on.
dfs_helper : Dict(a, List(a)), (a -> Bool), List(a), Set(a) -> Try(a, [NotFound])
	where [a.is_eq : a, a -> Bool, a.to_hash : a, Hasher -> Hasher]
dfs_helper = |graph, is_target, stack, visited| {
	match stack {
		[] => Err(NotFound)
		[.., current] => {
			rest = stack.drop_last(1)
			if is_target(current) {
				Ok(current)
			} else if visited.contains(current) {
				dfs_helper(graph, is_target, rest, visited)
			} else {
				new_visited = visited.insert(current)
				match graph.get(current) {
					Ok(neighbors) => {
						filtered = neighbors.keep_if(|n| !(new_visited.contains(n))).rev()
						new_stack = rest.concat(filtered)
						dfs_helper(graph, is_target, new_stack, new_visited)
					}
					Err(KeyNotFound) => {
						dfs_helper(graph, is_target, rest, new_visited)
					}
				}
			}
		}
	}
}

# A helper function for performing the breadth-first search.
#
# `graph`     : The graph to perform the search on.
# `is_target` : A function that returns true if a vertex is the target.
# `queue`     : A List of vertices to visit.
# `seen`      : A Set of all seen vertices.
bfs_helper : Dict(a, List(a)), (a -> Bool), List(a), Set(a) -> Try(a, [NotFound])
	where [a.is_eq : a, a -> Bool, a.to_hash : a, Hasher -> Hasher]
bfs_helper = |graph, is_target, queue, seen| {
	match queue {
		[] => Err(NotFound)
		[current, ..] => {
			rest = queue.drop_first(1)
			if is_target(current) {
				Ok(current)
			} else {
				match graph.get(current) {
					Ok(neighbors) => {
						filtered = neighbors.keep_if(|n| !(seen.contains(n)))
						new_queue = rest.concat(filtered)
						new_seen = filtered.fold(seen, Set.insert)
						bfs_helper(graph, is_target, new_queue, new_seen)
					}
					Err(KeyNotFound) => {
						bfs_helper(graph, is_target, rest, seen)
					}
				}
			}
		}
	}
}

# Test DFS with multiple paths
expect {
	actual = test_graph_multipath.dfs(|v| v.starts_with("C"), "A")
	expected = Ok("Correct")
	actual == expected
}

# Test BFS with multiple paths
expect {
	actual = test_graph_multipath.bfs(|v| v.starts_with("C"), "A")
	expected = Ok("Correct")
	actual == expected
}

# Test DFS
expect {
	actual = test_graph_small.dfs(|v| v.starts_with("F"), "A")
	expected = Ok("F-DFS")
	actual == expected
}

## Test BFS
expect {
	actual = test_graph_small.bfs(|v| v.starts_with("F"), "A")
	expected = Ok("F-BFS")
	actual == expected
}

# Test NotFound DFS
expect {
	actual = test_graph_small.dfs(|v| v == "not a node", "A")
	expected = Err(NotFound)
	actual == expected
}

# Test NotFound BFS
expect {
	actual = test_graph_small.bfs(|v| v == "not a node", "A")
	expected = Err(NotFound)
	actual == expected
}

# Test DFS large
expect {
	actual = test_graph_large.dfs(|v| v == "AE", "A")
	expected = Ok("AE")
	actual == expected
}

## Test BFS large
expect {
	actual = test_graph_large.bfs(|v| v == "AE", "A")
	expected = Ok("AE")
	actual == expected
}

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
		|> Graph.from_list

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
		|> Graph.from_list

test_graph_multipath =
	[
		("A", ["B", "Correct"]),
		("B", ["Correct", "Cwrong"]),
		("Correct", []),
		("Cwrong", []),
	]
		|> Graph.from_list
