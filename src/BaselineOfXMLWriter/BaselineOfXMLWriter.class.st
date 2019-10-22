Class {
	#name : #BaselineOfXMLWriter,
	#superclass : #BaselineOf,
	#classVars : [
		'LastVersionLoad'
	],
	#category : #BaselineOfXMLWriter
}

{ #category : #baselines }
BaselineOfXMLWriter >> baseline: spec [
   <baseline>
	spec for: #'common' do: [
		spec 
			package: #'XML-Writer-Core';
			package: #'XML-Writer-Tests'
		].

]
