from collections import defaultdict

# Function read_pairs_from_file reads pairs of individuals from a file called related_individuals.txt, which has related individuals in two columns. 
# The function reads lines from the file, splits each line into individuals, and adds valid pairs (lines with exactly two individuals) to a list called pairs
def read_pairs_from_file(filename):
    pairs = []
    with open(filename, 'r') as file:
        for line in file:
            individuals = line.strip().split()
            if len(individuals) == 2:
                pairs.append((individuals[0], individuals[1]))
    return pairs

# Function construct_graph(pairs) constructs a graph representation of the pairs. It creates a defaultdict of lists where the keys are individuals, and the values are lists of 
# related individuals. It ensures that each individual is connected to all others with whom they share a pair.
def construct_graph(pairs):
    graph = defaultdict(list)
    for pair in pairs:
        ind1, ind2 = pair
        graph[ind1].append(ind2)
        graph[ind2].append(ind1)
    return graph

# The function find_connected_components(graph) finds connected components in the graph. It traverses the graph to find groups of connected individuals, meaning individuals who are related.
def find_connected_components(graph):
    visited = set()
    components = []
    for node in graph:
        if node not in visited:
            component = []
            stack = [node]
            while stack:
                current = stack.pop()
                if current not in visited:
                    component.append(current)
                    visited.add(current)
                    stack.extend(graph[current])
            components.append(component)
    return components

# remove_related_individuals(pairs): Finds and returns a set of individuals to be removed. It utilizes the constructed graph and finds connected components. Then, it selects all individuals except 
# the first from each connected component and adds them to a set of individuals to be removed.
def remove_related_individuals(pairs):
    graph = construct_graph(pairs)
    components = find_connected_components(graph)
    removed_individuals = set()
    for component in components:
        for individual in component[1:]:
            removed_individuals.add(individual)
    return removed_individuals

# The function write_to_file(filename, individuals) writes a list of individuals to a file. It writes each individual from the given list to a file, with each individual on a separate line
def write_to_file(filename, individuals):
    with open(filename, 'w') as file:
        for individual in individuals:
            file.write(individual + '\n')

# Example usage:
pairs = read_pairs_from_file("related_individuals.txt")
removed_individuals = list(remove_related_individuals(pairs))
write_to_file("removed_individuals.txt", removed_individuals)
print("Individuals to remove have been written to removed_individuals.txt.")
