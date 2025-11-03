# -*- coding: utf-8 -*-
"""
Created on Mon Mar 24 12:20:38 2025

@author: colej
"""

from network_support_functions import network_entropy

import networkx as nx
import pandas as pd
import numpy as np
import os

from matplotlib import pyplot as plt

# %%

path = "C:\\Users\\colej\\MATLAB Drive\\Post Project Analysis\\Python Network Anaysis\\"
g_files = "Guided Data (Test)\\"
u_files = "Unguided Data (Test)\\"

test_file_1 = "GB3-test.xlsx"

edges = pd.read_excel(path + g_files + test_file_1, sheet_name="Connections")

G = nx.from_pandas_edgelist(edges, source="From", target="To")


# %%

c_dict = {
    "bp": "darkgreen",
    "sp": "limegreen",
    "do": "gray",
    "pc": "lightgray",
    "cp": "aquamarine",
    "fa": "darkturquoise",
    "sc": "tan",
    "bc": "goldenrod",
    "ss": "plum",
    "bs": "purple",
    "wh": "black",
    "bb": "navy",
}

nodelist = list(G.nodes())

# short_list = [item[:2] for item in my_list]

node_colors = [c_dict[node[:2]] for node in nodelist]
# node_colors = dict(zip(nodelist,node_colors))

# %%
plt.figure()
nx.draw(G, node_color=node_colors)
print(network_entropy(G))


# %% checking valid connections
p_L = ["bp", "sp", "do", "pc", "cp", "fa", "sc", "bc", "ss", "bs", "wh", "bb"]


e_L = list(G.edges())

e_L = [list(t) for i, t in enumerate(e_L)]

e_L = [[e[0][:2], e[1][:2]] for e in e_L]

# %% fucking hate this but here we go, invalid connections
invalid_conns = {
    ("bp", "wh"),
    ("sp", "wh"),
    ("sp", "bb"),
    ("do", "pc"),
    ("do", "cp"),
    ("do", "sc"),
    ("do", "bc"),
    ("do", "fa"),
    ("do", "bb"),
    ("pc", "cp"),
    ("pc", "sc"),
    ("pc", "bc"),
    ("pc", "fa"),
    ("pc", "wh"),
    ("cp", "wh"),
    ("cp", "bb"),
    ("sc", "bc"),
    ("sc", "wh"),
    ("sc", "bb"),
    ("bc", "wh"),
    ("bc", "bb"),
    ("fa", "wh"),
    ("fa", "bb"),
    ("wh", "wh"),
    ("wh", "bb"),
    ("bb", "bb"),
}

rev_set = {tuple(reversed(conn)) for conn in invalid_conns}

invalid_conns = invalid_conns.union(rev_set)


# %%
check = [tuple(item) in invalid_conns for item in e_L]
pass_fail = not (any(check))  # true originally meant there was an issue
total_issues = sum(check)

# %%
G2 = G

# %% Testing reduction

mark_battery = []
battery_neighbors = []
for node in G2.nodes():
    if "bb" in node:
        conns = list(G2.neighbors(node))
        battery_neighbors += conns
        mark_battery.append(node)


# %%
battery_neighbors = list(set(battery_neighbors))

# %%
G2.remove_nodes_from(mark_battery)

# %%

for node in battery_neighbors:
    G2.add_edge("bb_all", node)

# %%
print(network_entropy(G2))

# %%
nodelist = list(G.nodes())

# short_list = [item[:2] for item in my_list]

node_colors = [c_dict[node[:2]] for node in nodelist]
# node_colors = dict(zip(nodelist,node_colors))

plt.figure()
nx.draw(G, node_color=node_colors)
