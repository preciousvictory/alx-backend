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
