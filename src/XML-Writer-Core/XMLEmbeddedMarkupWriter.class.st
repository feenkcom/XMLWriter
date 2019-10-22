"
This is an abstract class for markup writers that support embedding markup using #with:.
"
Class {
	#name : #XMLEmbeddedMarkupWriter,
	#superclass : #XMLMarkupWriter,
	#instVars : [
		'hasEmbeddedStringMarkup',
		'hasEmbeddedMarkupWriters'
	],
	#category : #'XML-Writer-Core'
}

{ #category : #private }
XMLEmbeddedMarkupWriter >> embedBlock: aBlock [
	aBlock valueWithPossibleArgument: self writer
]

{ #category : #private }
XMLEmbeddedMarkupWriter >> embedCollection: aCollection [
	aCollection do: [:each | self embedValue: each]
]

{ #category : #private }
XMLEmbeddedMarkupWriter >> embedString: aString [
	self writer nextPutAll: aString
]

{ #category : #private }
XMLEmbeddedMarkupWriter >> embedValue: aValue [
	aValue ifNil: [^ self].

	aValue isString
		ifTrue: [^ self embedString: aValue].
	aValue isCollection
		ifTrue: [^ self embedCollection: aValue].
	aValue isBlock
		ifTrue: [^ self embedBlock: aValue].

	self error: 'Value object must be a string, collection or block'.
]

{ #category : #testing }
XMLEmbeddedMarkupWriter >> hasEmbeddedMarkup [
	^ hasEmbeddedStringMarkup | hasEmbeddedMarkupWriters
]

{ #category : #testing }
XMLEmbeddedMarkupWriter >> hasEmbeddedMarkupWriters [
	^ hasEmbeddedMarkupWriters
]

{ #category : #testing }
XMLEmbeddedMarkupWriter >> hasEmbeddedStringMarkup [
	^ hasEmbeddedStringMarkup
]

{ #category : #initialization }
XMLEmbeddedMarkupWriter >> initialize [
	super initialize.

	hasEmbeddedStringMarkup := false.
	hasEmbeddedMarkupWriters := false.
]

{ #category : #testing }
XMLEmbeddedMarkupWriter >> isWritingBody [
	^ isWritingBody ifNil: [isWritingBody := false]
]

{ #category : #private }
XMLEmbeddedMarkupWriter >> newMarkupWriterBeingPushed [
	self hasStartedWriting
		ifTrue: [
			self hasEmbeddedMarkup
				ifFalse: [self writeEmbeddedMarkupPrologue].
			hasEmbeddedMarkupWriters := true]
		ifFalse: [self write]
]

{ #category : #private }
XMLEmbeddedMarkupWriter >> newStringMarkupBeingWritten [
	self hasStartedWriting
		ifTrue: [
			self hasEmbeddedMarkup
				ifFalse: [self writeEmbeddedMarkupPrologue].
			hasEmbeddedStringMarkup := true]
		ifFalse: [self write]
]

{ #category : #private }
XMLEmbeddedMarkupWriter >> nextMarkupWriter: aMarkupWriter [
	self isWritingBody
		ifTrue: [
			self hasEmbeddedMarkup
				ifFalse: [self startWritingEmbeddedMarkup].
			aMarkupWriter parent: self.
			hasEmbeddedMarkupWriters := true]
		ifFalse: [self write]
]

{ #category : #private }
XMLEmbeddedMarkupWriter >> startWritingEmbeddedMarkup [	
	hasEmbeddedMarkup := true.
	self writeBeforeEmbeddedMarkup.
]

{ #category : #writing }
XMLEmbeddedMarkupWriter >> with: aStringOrCollectionOrBlock [
	self hasStartedWriting
		ifFalse: [
			self
				startWriting;
				writeBody: aStringOrCollectionOrBlock;
				finishWriting]
]

{ #category : #private }
XMLEmbeddedMarkupWriter >> write [
	self isWritingBody
		ifTrue: [
			self hasEmbeddedMarkup
				ifFalse: [self startWritingEmbeddedMarkup]]
		ifFalse: [self with: nil]
]

{ #category : #private }
XMLEmbeddedMarkupWriter >> writeBeforeEmbeddedMarkup [
]

{ #category : #private }
XMLEmbeddedMarkupWriter >> writeBody [
	self writeBody: nil
]

{ #category : #private }
XMLEmbeddedMarkupWriter >> writeBody: aStringOrCollectionOrBlock [
	aStringOrCollectionOrBlock embedInXMLMarkupWriter: self
]

{ #category : #private }
XMLEmbeddedMarkupWriter >> writeEmbeddedMarkupPrologue [
]
