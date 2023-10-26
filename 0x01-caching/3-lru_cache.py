#!/usr/bin/python3
"""LRUCache  module
"""
BaseCaching = __import__('base_caching').BaseCaching


class LRUCache(BaseCaching):
    """ a class LRUCache that inherits from BaseCaching
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
        # LRU-set new insert with d highest value of Recently used in self.ru
        for value in self.ru.values():
            if value > h:
                h = value
        self.ru[key] = h

        if len(self.cache_data) >= BaseCaching.MAX_ITEMS and \
                key not in self.cache_data:

            # get the least recently used key from self.ru
            keys = list(self.cache_data.keys())
            lru = keys[0]
            for k, value in self.ru.items():
                if value < self.ru[lru]:
                    lru = k

            # remove least recencly used key from self.cache_data and self.ru
            print('DISCARD: {}'.format(lru))
            if lru in self.ru:
                self.ru.pop(lru)
            self.cache_data.pop(lru)

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
