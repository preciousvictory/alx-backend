#!/usr/bin/env python3
"""
1-simple_pagination file
"""
import csv
import math
from typing import List


index_range = __import__('0-simple_helper_function').index_range


class Server:
    """Server class to paginate a database of popular baby names.
    """
    DATA_FILE = "Popular_Baby_Names.csv"

    def __init__(self):
        self.__dataset = None

    def dataset(self) -> List[List]:
        """Cached dataset
        """
        if self.__dataset is None:
            with open(self.DATA_FILE) as f:
                reader = csv.reader(f)
                dataset = [row for row in reader]
            self.__dataset = dataset[1:]

        return self.__dataset

    def get_page(self, page: int = 1, page_size: int = 10) -> List[List]:
        """ get page
        """
        assert isinstance(page, int) and isinstance(page_size, int)
        assert page > 0 and page_size > 0

        res = index_range(page, page_size)
        data = self.dataset()
        page_data = []

        try:
            page_data = data[res[0]:res[1]]
        except IndexError:
            return []

        return page_data

    def get_hyper(self, page: int = 1, page_size: int = 10) -> dict:
        """ get_hyper method
        """
        start, end = index_range(page, page_size)
        data = self.dataset()

        next_p = page + 1 if end < len(self.__dataset) else None
        prev = page - 1 if start > 0 else None

        total_pages = math.ceil(len(data) / page_size)

        new_dict = {
            'page_size': page_size,
            'page': page,
            'data': self.get_page(page, page_size),
            'next_page': next_p,
            'prev_page': prev,
            'total_pages': total_pages
        }
        return new_dict
