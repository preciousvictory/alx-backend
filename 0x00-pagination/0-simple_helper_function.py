#!/usr/bin/env python3
""" 0-simple_helper_function file
"""
from typing import Tuple


def index_range(page: int, page_size: int) -> Tuple[int, int]:
    page_start = 0
    page_end = 0

    for i in range(page):
        page_start = page_end
        page_end += page_size

    return (page_start, page_end)
