"""
Created on Mon Mar 24 12:18:46 2025

@author: colej
"""

import networkx as nx
import numpy as np
import scipy
import pandas as pd
from matplotlib import pyplot as plt


def network_entropy(G):
    """Calculate the shannon entropy for a network."""
    vk = dict(G.degree())
    vk = list(vk.values())  # get degree values
    maxk = np.max(vk)
    Pk = np.zeros(maxk + 1)  # P(k)

    for k in vk:
        Pk[k] = Pk[k] + 1

    Pk = Pk / sum(Pk)
    H = scipy.stats.entropy(Pk, base=len(Pk))

    return H


def gen_invalid():
    """Generate a set of invalid connections for checking. Speeds up code."""
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

    return invalid_conns.union(rev_set)


def check_invalid(G, invalid_conns):
    """Check if their on any invalid connections and how many there are."""
    e_L = list(G.edges())
    e_L = [list(t) for i, t in enumerate(e_L)]
    e_L = [[e[0][:2], e[1][:2]] for e in e_L]

    check = [tuple(item) in invalid_conns for item in e_L]

    return any(check), sum(check)


def plot_design(G, ax=None, name="Unnamed"):
    """Plot the device network."""
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
    node_colors = [c_dict[node[:2]] for node in nodelist]

    if ax is None:
        ax = plt.gca()

    ax.set_title(name)
    nx.draw(G, ax=ax, node_color=node_colors)

    return c_dict


def load_design(path):
    """Take in kumu excel file to networkx graph."""
    edges = pd.read_excel(path, sheet_name="Connections")
    G = nx.from_pandas_edgelist(edges, source="From", target="To")

    return G
