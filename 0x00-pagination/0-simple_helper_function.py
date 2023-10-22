#!/usr/bin/env python3
""" 0-simple_helper_function file
"""
from typing import Tuple


def index_range(page: int, page_size: int) -> Tuple[int, int]:
    """Retrieves the index range from a given page and page size.
    """
    page_start = (page - 1) * page_size
    page_end = page_start + page_size

    return (page_start, page_end)
