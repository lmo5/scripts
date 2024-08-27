import os
import sys
import re
from pathlib import Path
from typing import Dict, List, Tuple, Union

class Node:
    def __init__(self, name: str, is_file: bool):
        self.name = name
        self.is_file = is_file
        self.children: List[Node] = []

def clean_name(name: str) -> str:
    return re.sub(r'^[│├└─\s]+', '', name).rstrip()

def get_level(line: str) -> int:
    return len(re.match(r'^[^a-zA-Z]*', line).group())

def parse_structure(file_path: str) -> Node:
    with open(file_path, 'r') as file:
        lines = file.readlines()

    root = Node("root", False)
    level_folders: Dict[int, List[Node]] = {-1: [root]}
    
    for line in lines:
        level = get_level(line)
        name = clean_name(line)
        is_file = not name.endswith('/')

        if is_file:
            node = Node(name, True)
        else:
            node = Node(name.rstrip('/'), False)

        parent_level = level - 1
        while parent_level not in level_folders and parent_level >= -1:
            parent_level -= 1
        parent = level_folders[parent_level][-1]
        
        parent.children.append(node)
        
        if not is_file:
            if level not in level_folders:
                level_folders[level] = []
            level_folders[level].append(node)

    return root

def print_tree(node: Node, prefix: str = "", is_last: bool = True):
    print(prefix, "└── " if is_last else "├── ", node.name, sep="")
    prefix += "    " if is_last else "│   "
    
    for i, child in enumerate(node.children):
        is_last_child = i == len(node.children) - 1
        print_tree(child, prefix, is_last_child)

def create_structure(node: Node, parent_path: Path):
    path = parent_path / node.name
    if node.is_file:
        if not path.exists():
            path.touch()
            print(f"Created file: {path}")
        else:
            print(f"File already exists (skipped): {path}")
    else:
        if not path.exists():
            path.mkdir(parents=True)
            print(f"Created directory: {path}")
        else:
            print(f"Directory already exists (skipped): {path}")
        for child in node.children:
            create_structure(child, path)

def main():
    if len(sys.argv) != 2:
        print("Usage: python script.py <structure_file>")
        sys.exit(1)

    structure_file = sys.argv[1]
    if not os.path.isfile(structure_file):
        print(f"Error: File '{structure_file}' not found.")
        sys.exit(1)

    root = parse_structure(structure_file)

    print("Tree structure preview:")
    print_tree(root)

    print("\nDo you want to create this structure? (y/n)")
    response = input().lower()
    if response != 'y':
        print("Operation cancelled.")
        sys.exit(0)

    create_structure(root, Path.cwd())
    print("Structure creation process completed.")

if __name__ == "__main__":
    main()