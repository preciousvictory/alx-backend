#!/usr/bin/python3
"""MRUCache  module
"""
BaseCaching = __import__('base_caching').BaseCaching


class MRUCache(BaseCaching):
    """ a class MRUCache that inherits from BaseCaching
    and is a caching system
    """
    def __init__(self):
        '''Initialize Child class'''
        super().__init__()
        self.ru = {}

    def put(self, key, item):
        """ Add an item in the cache
        """
        if key is None or item is None:
            return

        h = 0
        # MRU-set new insert with d highest value of Recently used in self.ru
        for value in self.ru.values():
            if value > h:
                h = value
        self.ru[key] = h

        if len(self.cache_data) >= BaseCaching.MAX_ITEMS and \
                key not in self.cache_data:

            # get the most recently used key from self.ru
            keys = list(self.cache_data.keys())
            mru = keys[0]
            for key, value in self.ru.items():
                if value > self.ru[mru]:
                    mru = key

            # remove least recencly used key from self.cache_data and self.ru
            print('DISCARD: {}'.format(mru))
            if mru in self.ru:
                self.ru.pop(mru)
            self.cache_data.pop(mru)

        # insert new key into cache_data
        self.cache_data[key] = item

    def get(self, key):
        """ Get an item by key
        """
        if key is None or key not in self.cache_data:
            return None
        if key in self.ru:
            self.ru[key] += 1
        return self.cache_data[key]
