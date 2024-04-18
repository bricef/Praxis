#!/usr/bin/env python

import sys
from slut import *

class Atlantis(World):
    def onSetup(self):
        self.name = "Camera"
        self.showCoordinates = True

    def onDraw(self):
        cuboid(0, 0, 0, 1, 1, 1)

    def onMouseButtonDown(self, event):
        #self.camera.moveBy(1.5, 0, 0)
        #self.camera.rotBy(0, 0, 45)
        #self.camera.orbitBy(0, 45, 0)
        #self.camera.zoomBy(10)

        #self.camera.moveBy(Tween(0.5, 0, 0, 2))
        #self.camera.rotBy(Tween(0, 0, 20, 2))
        #self.camera.orbitBy(Tween(0, 76, 0, 2))

        #self.camera.moveBy(Thrust(0.0, 0.1, 0.0))
        #self.camera.rotBy(Thrust(10.0, 0.0, 0.0))
        #self.camera.orbitBy(Thrust(0.0, 180.0, 0.0))

        #self.camera.moveTo(0.5, 0, 0)
        #self.camera.rotTo(0, 0, 45)
        #self.camera.orbitTo(0, -45, 0.0)
        #self.camera.zoomTo(80)

        self.camera.moveTo(Tween(0.5, 0, 0, 2))
        self.camera.rotTo(Tween(0, 0, 20, 2))
        self.camera.orbitTo(Tween(0, 20, 0, 2))

    def onKeyDown(sefl, event):
      if event.key == ord('q'):
        sys.exit(1)
      


atlantis = Atlantis()
atlantis.run()
