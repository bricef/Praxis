
class GildedRose(object):

    def __init__(self, items):
        self.items = items

    def update_quality(self):
        for item in self.items:
            item.update()

def update_aged_brie(item):
    item.sell_in -= 1
    if item.quality < 50:
        item.quality = item.quality + 1
        if item.sell_in < 0:
            item.quality = item.quality + 1

def update_sulfuras(item):
    pass

def update_concert_ticket(item):
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

def update_default(item):
    if item.quality > 0:
        item.quality = item.quality - 1
    item.sell_in -= 1
    if item.sell_in < 0:
        if item.quality > 0:
            item.quality = item.quality - 1

class Item:
    def __init__(self, name, sell_in, quality):
        self.name = name
        self.sell_in = sell_in
        self.quality = quality

    def update(self):
        item = self
        match item.name:
            case "Aged Brie":
                update_aged_brie(self)

            case "Sulfuras, Hand of Ragnaros":
                update_sulfuras(self)

            case "Backstage passes to a TAFKAL80ETC concert":
                update_concert_ticket(self)
                 
            case _:
                update_default(item)

    def __repr__(self):
        return "%s, %s, %s" % (self.name, self.sell_in, self.quality)
