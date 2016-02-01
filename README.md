# Linked Ideas

The application is to lay out some ideas in the computer, allowing you to connect them, reorder them and classify them with color codes

On the other hand, the connexions between ideas can have text on its own as a way to 'explain' the connexion of ideas.

## Feature Roadmap

- [x] click in 'canvas' and type a concept, press 'enter' and present it on screen
- [x] edit a concept
- [x] delete a concept
- [x] save and load files
- [x] create a link between 2 concepts with description text
- [ ] allow moving concepts
- [ ] add color to concepts
- [ ] resize concepts
- [ ] edit link description text
- [ ] delete link between concepts
- [ ] add color to concepts
- [ ] moving in canvas
- [ ] panning in canvas
- [ ] zooming in canvas
- [ ] select a group of concepts (and their links)
- [ ] keyboard shortcuts
- [ ] automatically reorganize concepts and links
- [ ] undo capabilities

### Click on 'canvas' and type a concept, press 'enter' and present it on screen

- [x] draw canvas
- [x] accept click
- [x] draw a string in a certain position on click
- [x] create text field and focus on it
- [x] when editing a concept, 'escape key' to cancel and delete the concept
- [x] accept enter and just render as text
- [x] when clicking a concept make it editable
- [ ] \(optional\) when pressing 'enter' and the concept is blank, remove the concept

### Save and load files

- [x] make Concept: NSCoding compatible
- [x] serialize root elements
- [x] deserialize elements
- [x] render deserialized elements correctly on canvas

### Create a link between 2 concepts with description text

- [x] add selector _concept mode_ and _link mode_
- [x] do not add a new concept on click while on _link mode_
- [x] call corresponding actions on drag link
- [x] call corresponding actions on drag end
- [x] show line when dragging the link
- [x] show a text field when mouse is released
- [x] enter will render the text
- [x] click links to edit its text
- [x] store links in file
- [x] load links from file

## select concepts

- [ ] select concept when clicking on it
- [ ] when selected, pressing 'enter' will make the concept editable
- [ ] double click on concept will make it editable
- [ ] when selected, pressing 'delete' will remove the concept

- [ ] select link when clicking on it
- [ ] when selected, pressing 'enter' will make the link editable
- [ ] double click on link will make it editable
- [ ] when selected, pressing 'delete' will remove the link

## feature flag logging with tags

## allow move concepts

### Pending

- [ ] handle click outside of ConceptView
- [ ] improve unit testing to components
- [ ] click with position in UI testing
- [ ] improve UI testing
- [ ] highlight of selected elements
- [ ] refactoring text field editable based view
- [ ] click link to select it
- [ ] press delete key when selected link to delete it
- [ ] add arrow mark
