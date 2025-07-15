# -*- coding: utf-8 -*-

class GildedRose(object):

    def __init__(self, items):
        self.items = items

    def update_quality(self):
        for item in self.items:
            match item.name:
                case "Aged Brie":
                    item.sell_in -= 1
                    if item.quality < 50:
                        item.quality = item.quality + 1
                        if item.sell_in < 0:
                            item.quality = item.quality + 1

                case "Sulfuras, Hand of Ragnaros":
                    pass

                case "Backstage passes to a TAFKAL80ETC concert":
                    if item.quality < 50:
                        item.quality = item.quality + 1
                        if item.sell_in < 11:
                            item.quality = item.quality + 1
                        if item.sell_in < 6:
                            item.quality = item.quality + 1
                    item.quality = min(item.quality, 50)
                    item.sell_in -= 1
                    if item.sell_in < 0:
                        item.quality = 0 
                case _:
                    if item.quality > 0:
                        item.quality = item.quality - 1
                    item.sell_in -= 1
                    if item.sell_in < 0:
                        if item.quality > 0:
                            item.quality = item.quality - 1
                    
                    

                        

            # if item.name in ["Backstage passes to a TAFKAL80ETC concert", "Conjured Mana Cake", "Sulfuras, Hand of Ragnaros", "Aged Brie", "+5 Dexterity Vest", "Elixir of the Mongoose"]:
            #     continue 

            # if item.name != "Aged Brie" and item.name != "Backstage passes to a TAFKAL80ETC concert":
            #     if item.quality > 0:
            #         if item.name != "Sulfuras, Hand of Ragnaros":
            #             item.quality = item.quality - 1
            # else:
            #     pass
            # if item.name != "Sulfuras, Hand of Ragnaros":
            #     item.sell_in = item.sell_in - 1
            # if item.sell_in < 0:
            #     if item.name != "Aged Brie":
            #         if item.name != "Backstage passes to a TAFKAL80ETC concert":
            #             if item.quality > 0:
            #                 if item.name != "Sulfuras, Hand of Ragnaros":
            #                     item.quality = item.quality - 1
            #         else:
            #             item.quality = item.quality - item.quality
            #     else:
            #         if item.quality < 50:
            #             item.quality = item.quality + 1


class Item:
    def __init__(self, name, sell_in, quality):
        self.name = name
        self.sell_in = sell_in
        self.quality = quality

    def __repr__(self):
        return "%s, %s, %s" % (self.name, self.sell_in, self.quality)
