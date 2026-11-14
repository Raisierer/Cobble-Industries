ServerEvents.recipes(event => {
const OLD = 'create_new_age:radioactive_thorium'
const NEW = 'createnuclear:thorium_dust'

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
