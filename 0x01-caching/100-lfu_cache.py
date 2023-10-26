#!/usr/bin/python3
"""LFUCache  module
"""
BaseCaching = __import__('base_caching').BaseCaching


class LFUCache(BaseCaching):
    """ a class LFUCache that inherits from BaseCaching
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

        if key in self.ru:
            self.ru[key] += 1
        else:
            self.ru[key] = 1

        if len(self.cache_data) >= BaseCaching.MAX_ITEMS and \
                key not in self.cache_data:

            # get the least recently used key from self.ru
            keys = list(self.cache_data.keys())
            lfu = keys[0]
            for k, value in self.ru.items():
                if value < self.ru[lfu] and k is not key:
                    lfu = k

            # remove least recently used key from self.cache_data and self.ru
            print('DISCARD: {}'.format(lfu))
            if lfu in self.ru:
                self.ru.pop(lfu)
            self.cache_data.pop(lfu)

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
