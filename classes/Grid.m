classdef Grid
    properties
        arakawaType % 'A', 'B', 'C', 'D', 'E'
        spatialDimension
        temporalDimension
        dx
        dy
        dz
        dt
        xVector % vector with x-coordinates of box corners
        yVector % vector with y-coordinates of box corners
        zVector % vector with z-coordinates of box corners
        tVector
        xVectorForU
        yVectorForU
        zVectorForU
        xVectorForV
        yVectorForV
        zVectorForV
        xVectorForW
        yVectorForW
        zVectorForW
    end
end