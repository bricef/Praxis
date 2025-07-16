
def clamp(minimum, x, maximum):
    return max(minimum, min(x, maximum))

class GildedRose(object):
    def __init__(self, items):
        self.items = items

    def update_quality(self):
        for item in self.items:
            item.update()

# class Item:
#     def __init__(self, name, sell_in, quality):
#         self.name = name
#         self.sell_in = sell_in
#         self.quality = quality

#     def __repr__(self):
#         return "%s, %s, %s" % (self.name, self.sell_in, self.quality)

class Item:
    def __init__(self, name, sell_in, quality, update_fn=None):
        self.name = name
        self.sell_in = sell_in
        self.quality = max(0, quality)
        self.update_fn = update_fn

    def decay(self):
        self.quality -= 1

    def _default_update(self):
        if self.quality >= 0:
            self.decay()

        self.sell_in -= 1

        if self.sell_in < 0:
            self.decay()

        self.quality = clamp( 0, self.quality, 50)

    def update(self):
        if self.update_fn:
            self.update_fn(self)
        else:
            self._default_update()
        
    def __repr__(self):
        return "%s, %s, %s" % (self.name, self.sell_in, self.quality)

class Ticket(Item):
    def update(self):
        if self.quality < 50:
            self.quality = self.quality + 1
            if self.sell_in < 11:
                self.quality = self.quality + 1
            if self.sell_in < 6:
                self.quality = self.quality + 1
        self.quality = min(self.quality, 50)
        self.sell_in -= 1
        if self.sell_in < 0:
            self.quality = 0

class Legendary(Item):
    def __init__(self, name, sell_in=0):
        super().__init__(name=name, sell_in=sell_in, quality=80)

    def update(self):
        pass

class Aging(Item):
    def decay(self):
        self.quality +=1

class Conjured(Item):
    def decay(self):
        self.quality -= 2