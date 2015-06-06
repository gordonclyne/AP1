/*
 *  InvalidPoint.h
 *  AP1
 *
 *  Created by Casey Marshall on 9/21/10.
 *  Copyright 2010 Modal Domains. All rights reserved.
 *
 */

#define CGInvalidPoint CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX)
#define isInvalidCGPoint(p) ((p).x == CGFLOAT_MAX && ((p).y == CGFLOAT_MAX))