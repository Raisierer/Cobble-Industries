ServerEvents.recipes(event => {
const OLD = 'alexscaves:uranium'
const NEW = 'createnuclear:raw_uranium'

// Alle Rezept-Inputs
event.replaceInput(
    { input: OLD },
    OLD,
    NEW
)

// Alle Rezept-Outputs
event.replaceOutput(
    { output: OLD },
    OLD,
    NEW
)


})
