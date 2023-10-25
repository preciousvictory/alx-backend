#!/usr/bin/python3
"""LIFOCache  module
"""
BaseCaching = __import__('base_caching').BaseCaching


class LIFOCache(BaseCaching):
    """ a class LIFOCache that inherits from BaseCaching
    and is a caching system
    """
    def __init__(self):
        '''Initialize Child class'''
        super().__init__()

    def put(self, key, item):
        """ Add an item in the cache
        """
        if key is None or item is None:
            return
        if key in self.cache_data:
            del self.cache_data[key]
        if len(self.cache_data) >= BaseCaching.MAX_ITEMS and \
                key not in self.cache_data:
            keys = list(self.cache_data.keys())
            print('DISCARD: {}'.format(keys[-1]))
            self.cache_data.popitem()

        self.cache_data[key] = item

    def get(self, key):
        """ Get an item by key
        """
        if key is None or key not in self.cache_data:
            return None
        return self.cache_data[key]
