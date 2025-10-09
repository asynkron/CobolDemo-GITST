"""Build a dependency graph of IBM i source members and cluster them."""

import json
import re
from pathlib import Path

import networkx as nx

BASE_DIR = Path(__file__).resolve().parents[1]

# Directories that hold IBM i source members we want to analyse.
SOURCE_DIRECTORIES = [
    "QCBLSRC",
    "QRPGSRC",
    "QRPGLESRC",
    "QCLSRC",
    "QCLLESRC",
    "QCMDSRC",
    "QDDSSRC",
    "QSQLSRC",
    "QSQLPRC",
]

# File suffixes we treat as compilable source artefacts.
VALID_SUFFIXES = {
    ".CBL",
    ".RPG",
    ".RPGLE",
    ".SQLRPGLE",
    ".CLP",
    ".CLLE",
    ".CMD",
    ".DSPF",
    ".PF",
    ".LF",
    ".SQL",
    ".PRC",
}

# Simple heuristics for CALL-style invocations across COBOL, RPG, and CL.
CALL_PATTERNS = [
    re.compile(r"\bCALLP?\b\s*(?:\(|\s+)?['\"]?([A-Z0-9#$@_]+)", re.IGNORECASE),
    re.compile(r"\bCALL\s+PGM\s*\(\s*['\"]?([A-Z0-9#$@_]+)", re.IGNORECASE),
]

# Copybook/include references link programs to shared structures.
COPY_PATTERNS = [
    re.compile(r"\bCOPY\b\s+['\"]?([A-Z0-9#$@_]+)", re.IGNORECASE),
    re.compile(r"EXEC\s+SQL\s+INCLUDE\s+([A-Z0-9#$@_]+)", re.IGNORECASE),
    re.compile(r"\bINCLUDE\b\s+['\"]?([A-Z0-9#$@_]+)", re.IGNORECASE),
]


def iter_source_files():
    """Yield all IBM i source members with extensions we know how to parse."""
    for directory in SOURCE_DIRECTORIES:
        folder = BASE_DIR / directory
        if not folder.exists():
            continue
        for path in folder.iterdir():
            if not path.is_file():
                continue
            if path.suffix.upper() not in VALID_SUFFIXES:
                continue
            yield path


def module_name_from_path(path: Path) -> str:
    """Return the member name without the IBM i suffix (e.g., ZBCONDET)."""
    return path.name.split(".")[0].upper()


def extract_dependencies(text: str):
    """Locate program and copybook references in the provided source text."""
    dependencies = set()
    for pattern in CALL_PATTERNS:
        for match in pattern.findall(text):
            if match:
                dependencies.add(match.upper())
    for pattern in COPY_PATTERNS:
        for match in pattern.findall(text):
            if match:
                dependencies.add(match.upper())
    return dependencies


def build_graph():
    """Construct a directed graph of modules pointing to the artefacts they use."""
    module_to_path = {}
    graph = nx.DiGraph()

    for path in iter_source_files():
        module = module_name_from_path(path)
        module_to_path[module] = str(path.relative_to(BASE_DIR))
        graph.add_node(module)

    for module, rel_path in module_to_path.items():
        path = BASE_DIR / rel_path
        text = path.read_text(errors="ignore")
        dependencies = extract_dependencies(text)
        for dep in dependencies:
            graph.add_node(dep)
            if module != dep:
                graph.add_edge(module, dep)

    return graph, module_to_path


def detect_communities(graph: nx.Graph):
    """Cluster modules with Louvain (fallback to greedy modularity if unavailable)."""
    undirected = graph.to_undirected()
    try:
        from networkx.algorithms.community import louvain_communities

        communities = louvain_communities(undirected, seed=42)
        algo = "louvain"
    except Exception:
        from networkx.algorithms.community import greedy_modularity_communities

        communities = greedy_modularity_communities(undirected)
        algo = "greedy_modularity"
    return algo, communities


def main():
    """Emit a JSON summary of detected module communities for downstream reporting."""
    graph, module_to_path = build_graph()
    algo, communities = detect_communities(graph)

    community_data = []
    for idx, community in enumerate(sorted(communities, key=lambda c: -len(c))):
        members = sorted(community)
        internal_edges = graph.subgraph(community).number_of_edges()
        boundary_edges = 0
        for node in community:
            for neighbor in graph.successors(node):
                if neighbor not in community:
                    boundary_edges += 1
        community_data.append(
            {
                "community": idx + 1,
                "size": len(members),
                "members": members,
                "internal_edges": internal_edges,
                "outbound_edges": boundary_edges,
            }
        )

    summary = {
        "algorithm": algo,
        "node_count": graph.number_of_nodes(),
        "edge_count": graph.number_of_edges(),
        "communities": community_data,
    }

    print(json.dumps(summary, indent=2))


if __name__ == "__main__":
    main()
