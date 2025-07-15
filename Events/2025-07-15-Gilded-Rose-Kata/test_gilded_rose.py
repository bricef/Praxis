# -*- coding: utf-8 -*-
import unittest

from gilded_rose import *


class GildedRoseTest(unittest.TestCase):
    def test_conjured_item_decays_by_two(self):
        item = Conjured(name="foo", sell_in=10, quality=10)
        
        item.update()

        self.assertEqual(item.quality, 8)

    def test_expired_conjured_item(self):
        item = Conjured(name="foo", sell_in=0, quality=4)

        item.update()

        self.assertEqual(item.quality, 0)
    
    def test_item_cannot_be_created_with_negative_quality(self):
        item = Item(name="", sell_in=0, quality=-1)

        self.assertGreaterEqual(item.quality, 0)

    def test_item_quality_cannot_decay_below_zero(self):
        item = Item(name="", sell_in=0, quality=-1)

        item.update()

        self.assertGreaterEqual(item.quality, 0)


        
if __name__ == '__main__':
    unittest.main()
