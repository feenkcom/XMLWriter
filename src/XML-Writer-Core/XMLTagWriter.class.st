"
This class writes XML tags. You can specifiy the attributes of the start tag using the #attribute* messages, and you can add xmlns: namespace declarations using the #xmlns* messages.

Empty elements will generate self-closed tags like ""<empty/>"" unless isCanonical is enabled or outputsSelfClosingTags is disabled.

Redundant namespace declarations won't be generated unless omitsRedundantXMLNSDeclarations is disabled.
"
Class {
	#name : #XMLTagWriter,
	#superclass : #XMLEmbeddedMarkupWriter,
	#instVars : [
		'name',
		'xmlnsDeclarations',
		'attributes'
	],
	#category : #'XML-Writer-Core'
}

{ #category : #accessing }
XMLTagWriter >> attributeAt: aName [
	^ self attributeAt: aName ifAbsent: ['']
]

{ #category : #accessing }
XMLTagWriter >> attributeAt: aName ifAbsent: aBlock [
	^ self attributes at: aName ifAbsent: aBlock
]

{ #category : #accessing }
XMLTagWriter >> attributeAt: aName ifAbsentPut: aBlock [
	^ self attributes at: aName ifAbsentPut: aBlock
]

{ #category : #accessing }
XMLTagWriter >> attributeAt: aName put: aValue [
	^ self attributes at: aName put: aValue
]

{ #category : #accessing }
XMLTagWriter >> attributes [
	^ attributes ifNil: [attributes := OrderPreservingStringDictionary new]
]

{ #category : #accessing }
XMLTagWriter >> attributes: anAssociationCollection [
	attributes := OrderPreservingStringDictionary newFrom: anAssociationCollection
]

{ #category : #'embedding markup' }
XMLTagWriter >> content: aStringOrBlockOrCollection [
	self deprecated: 'use #with: instead'.

	^ self with: aStringOrBlockOrCollection.
]

{ #category : #private }
XMLTagWriter >> embedString: aString [
	self writer string: aString
]

{ #category : #testing }
XMLTagWriter >> hasAttributes [
	^ attributes notNil and: [attributes notEmpty]
]

{ #category : #testing }
XMLTagWriter >> hasXMLNSDeclarations [
	^ xmlnsDeclarations notNil and: [xmlnsDeclarations notEmpty]
]

{ #category : #testing }
XMLTagWriter >> includesAttribute: anAttribute [
	^ self attributes includesKey: anAttribute
]

{ #category : #testing }
XMLTagWriter >> includesXMLNS: aPrefix [
	^ self xmlnsDeclarations includesKey: aPrefix
]

{ #category : #testing }
XMLTagWriter >> isTagWriter [
	^ true
]

{ #category : #accessing }
XMLTagWriter >> name [
	^ name ifNil: [name := '']
]

{ #category : #accessing }
XMLTagWriter >> name: aName [
	name := aName
]

{ #category : #private }
XMLTagWriter >> setAttributes: aDictionary [
	attributes := aDictionary
]

{ #category : #private }
XMLTagWriter >> setXMLNSDeclarations: aDictionary [ 
	xmlnsDeclarations := aDictionary
]

{ #category : #private }
XMLTagWriter >> writeAttributes [
	attributes ifNotNil: [
		self
			writeKeysAndValuesFrom: self attributes
			with: [:attrName :attrValue |
				self writer
					writeName: attrName value: attrValue]]
]

{ #category : #private }
XMLTagWriter >> writeBeforeEmbeddedMarkup [
	self writer
		nextPut: $>;
		indent
]

{ #category : #private }
XMLTagWriter >> writeEmbeddedMarkupPrologue [
	self writer
		nextPut: $>;
		formatAfterStartTag: self
]

{ #category : #private }
XMLTagWriter >> writeEndTag [
	self writer
		nextPutAll: '</';
		writeName: self name;
		nextPut: $>
]

{ #category : #private }
XMLTagWriter >> writeEpilogue [
	(self hasEmbeddedMarkup
		or: [self writer isCanonical
			or: [self writer outputsSelfClosingTags not]])
		ifTrue: [
			self hasEmbeddedMarkup
				ifFalse: [
					self writer
						nextPut: $>;
						formatAfterStartTag: self].
			self writer
				formatBeforeEndTag: self;
				nextPut: $<;
				nextPut: $/;
				writeName: self name;
				nextPut: $>;
				formatAfterEndTag: self]
		ifFalse: [
			self writer
				nextPut: $/;
				nextPut: $>;
				formatAfterEndTag: self]
]

{ #category : #private }
XMLTagWriter >> writeKeysAndValuesFrom: aDictionary with: aTwoArgumentBlock [
	self writer isCanonical
		ifTrue: [
			aDictionary keys asSortedCollection do: [:each |
				aTwoArgumentBlock value: each value: (aDictionary at: each)]]
		ifFalse: [aDictionary keysAndValuesDo: aTwoArgumentBlock]
]

{ #category : #private }
XMLTagWriter >> writePrologue [
	self writer
		formatBeforeStartTag: self;
		nextPut: $<;
		writeName: self name.
	xmlnsDeclarations
		ifNotNil: [self writer writeXMLNSDeclarations: xmlnsDeclarations].
	attributes
		ifNotNil: [self writer writeAttributes: attributes].
]

{ #category : #private }
XMLTagWriter >> writeXmlnsDeclarations [
	xmlns ifNotNil: [self writer writeName: 'xmlns' value: self xmlns].

	self xmlnsPrefixes
		ifNotEmpty: [
			self
				writeKeysAndValuesFrom: self xmlnsPrefixes
				with: [:prefix :uri | self writer writeName: 'xmlns:', prefix value: uri]].
]

{ #category : #accessing }
XMLTagWriter >> xmlns [
	"default namespace"
	^ self xmlnsDeclarations at: ''
]

{ #category : #accessing }
XMLTagWriter >> xmlns: aURI [
	"set default namespace"
	self xmlnsDeclarations at: '' put: aURI
]

{ #category : #accessing }
XMLTagWriter >> xmlnsAt: aPrefix [
	^ self xmlnsDeclarations at: aPrefix ifAbsent: ['']
]

{ #category : #accessing }
XMLTagWriter >> xmlnsAt: aPrefix ifAbsent: aBlock [
	^ self xmlnsDeclarations at: aPrefix ifAbsent: aBlock
]

{ #category : #accessing }
XMLTagWriter >> xmlnsAt: aPrefix ifAbsentPut: aBlock [
	^ self xmlnsDeclarations at: aPrefix ifAbsentPut: aBlock
]

{ #category : #accessing }
XMLTagWriter >> xmlnsAt: aPrefix put: aValue [
	^ self xmlnsDeclarations at: aPrefix put: aValue
]

{ #category : #accessing }
XMLTagWriter >> xmlnsDeclarations [
	^ xmlnsDeclarations
		ifNil: [xmlnsDeclarations := OrderPreservingStringDictionary new: 5]
]

{ #category : #accessing }
XMLTagWriter >> xmlnsDeclarations: anAssociationCollection [
	"set xmlns decls using a dictionary or array of prefix/uri associations.
	empty prefix is default xmlns."
	xmlnsDeclarations :=
		OrderPreservingStringDictionary newFrom: anAssociationCollection
]

{ #category : #accessing }
XMLTagWriter >> xmlnsPrefixes [
	^ xmlnsPrefixes ifNil: [xmlnsPrefixes := OrderPreservingDictionary defaultValue: '']
]

{ #category : #accessing }
XMLTagWriter >> xmlnsPrefixes: aDictionaryOrArray [
	aDictionaryOrArray associationsDo: [:each |
		each key isEmptyOrNil
			ifTrue: [self xmlns: each value]
			ifFalse: [self xmlnsAt: each key put: each value]]
]
