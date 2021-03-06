"
""I represent an ArrowHeadMorph to draw a Sierpinski curve using parameters order and length"".

""Instance variables:
  - order : the order of the recursion : from 0 to ... 
  - length : the length of one side of the arrowhead in pixels 
  - angle : the direction of the line when drawing 
  - point : the starting position of the algorithm is set at (0 @ 0)
  - points : the calculated points that are set to the PolygonMorph vertex array
  - sixtyDegrees : ((pi/2)  / 3) * 2
""

"
Class {
	#name : #ArrowHeadMorph,
	#superclass : #PolygonMorph,
	#instVars : [
		'order',
		'length',
		'angle',
		'points',
		'point',
		'sixtyDegrees'
	],
	#classInstVars : [
		'order',
		'length'
	],
	#category : #'Recursive-Curves'
}

{ #category : #calculations }
ArrowHeadMorph >> curveWithOrder: anOrder length: aLength angle: anAngle [
	"calculate the curve and append the points to the points collection of the arrowhead"

	anOrder == 0
		ifTrue: [ self drawLine: aLength ]
		ifFalse: [ self
				curveWithOrder: anOrder - 1
				length: aLength / 2
				angle: -1 * anAngle.
			self turn: anAngle.
			self curveWithOrder: anOrder - 1 length: aLength / 2 angle: anAngle.
			self turn: anAngle.
			self
				curveWithOrder: anOrder - 1
				length: aLength / 2
				angle: -1 * anAngle ]
]

{ #category : #calculations }
ArrowHeadMorph >> drawLine: aLength [
	"add a line with length using angle as direction"

	| newX newY newPoint |
	newX := aLength * angle cos.
	newY := aLength * angle sin.
	newPoint := point + (newX @ newY) asIntegerPoint.
	points add: newPoint.
	point := newPoint
]

{ #category : #calculations }
ArrowHeadMorph >> generatePoints [
	"generate the points for an arrowhead curve with length and order"

	points add: point.
	order odd
		ifTrue: [ self turn: sixtyDegrees ].
	self curveWithOrder: order length: length angle: -1 * sixtyDegrees.
	self setVertices: points
]

{ #category : #initialization }
ArrowHeadMorph >> initialize [
	"initialize the instance variables with default values"

	super initialize.
	self beStraightSegments.
	self makeOpen.
	self lineColor: Color white.
	self lineWidth: 2.
	self order: 0.
	self length: 0.
	angle := 0.
	points := OrderedCollection new.
	point := 0 @ 0.
	sixtyDegrees := Float halfPi / 3 * 2
]

{ #category : #accessing }
ArrowHeadMorph >> length [
	"return the length in pixels for the arrowhead"

	^ length
]

{ #category : #accessing }
ArrowHeadMorph >> length: anInteger [
	"set the length in pixels for the arrowhead"

	length := anInteger
]

{ #category : #accessing }
ArrowHeadMorph >> order [
	"return the order of the arrowhead"

	^ order
]

{ #category : #accessing }
ArrowHeadMorph >> order: anInteger [
	"set the order of the arrowhead"

	order := anInteger
]

{ #category : #calculations }
ArrowHeadMorph >> turn: aFloat [
	"turn the angle of the drawing line with aFloat (+/-60 degrees) and guarantee the angle to be in the range [0..2*pi]"

	angle := angle + aFloat rem: Float pi * 2
]
