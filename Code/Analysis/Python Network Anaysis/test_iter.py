# -*- coding: utf-8 -*-
"""
Created on Mon Mar 24 14:30:50 2025

@author: colej
"""

from network_support_functions import (
    network_entropy,
    load_design,
    plot_design,
    gen_invalid,
    check_invalid,
)

import networkx as nx
import pandas as pd
import numpy as np
import os

from matplotlib import pyplot as plt


# %%
path = "C:\\Users\\colej\\MATLAB Drive\\Post Project Analysis\\Python Network Anaysis\\"
g_files = "Guided Data (Test)\\"
u_files = "Unguided Data (Test)\\"

folder = g_files

designs = os.listdir(path + folder)

# fig, axes = plt.subplots(3, 2)
# axes = axes.flatten()


names = [item[:2] for item in designs]
names = sorted(list(set(names)))

current_design = names[0]
# print(current_design)
track = 0

ent_all = [0] * len(names)  # all data per person (list)
ent_ave = [0] * len(names)  # ave ent per person (float)
ent_var = [0] * len(names)  # var ent per person (float)
ent_idv = [0]  # local tracker (list)


invalid_conns = gen_invalid()

inval_all = [0] * len(names)  # invalid track per device (list)
inval_ttl = [0] * len(names)  # invalid sum per device (list)
inval_dev = [0] * len(names)  # total invalid devices per person (list)
inval_ave = [0] * len(names)  # ave invalid connections per person (list)

inval_bool = []  # local tracker (list)
inval_alls = []
inval_conn = []


# %%
# for i, (design, ax) in enumerate(zip(designs, axes)):
designs.append("")
for design in designs:
    # check subject
    print(design)
    if design[:2] != current_design:
        # place everything into the right place
        ent_all[track] = ent_idv
        ent_ave[track] = np.mean(ent_idv)
        ent_var[track] = np.var(ent_idv)

        inval_all[track] = inval_bool
        inval_ttl[track] = inval_conn
        inval_dev[track] = np.sum(inval_bool)

        print(inval_bool)
        print(inval_conn)
        if inval_conn != []:
            inval_ave[track] = np.mean(inval_conn)
        else:
            inval_ave[track] = 0

        # reset stuff
        current_design = design[:2]  # check current design
        track += 1  # list index tracker

        ent_idv = []  # local tracker (list)
        inval_bool = []  # local tracker (list)
        inval_conn = []

    if track == len(names):
        break

    G = load_design(path + folder + design)
    ent_idv.append(network_entropy(G))

    inval_if, inval_total = check_invalid(G, invalid_conns)

    inval_bool.append(inval_if)
    inval_alls.append(inval_total)

    if inval_total > 0:
        inval_conn.append(inval_total)

    # plot_design(G, ax=ax, name=design[:-5])

    # figure out how to store it


plt.tight_layout()
