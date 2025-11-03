# -*- coding: utf-8 -*-
"""
Created on Wed May  7 15:36:47 2025

@author: colej
"""


def connection_checker(G):

    nodelist = list(G.nodes())

    e_L = list(G.edges())

    e_L = [list(t) for i, t in enumerate(e_L)]

    e_L = [[e[0][:2], e[1][:2]] for e in e_L]

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

    check = [tuple(item) in invalid_conns for item in e_L]
    pass_fail = not (any(check))  # true originally meant there was an issue
    total_issues = sum(check)

    return pass_fail, total_issues
