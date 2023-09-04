
class Mather {

    var programs: [Arg: Program]
    var modifications: [Modification]
    // var filters: [Filter] = []

    init(programs: [Arg: Program], modifications: [Modification]) {
        self.programs = programs
        self.modifications = modifications
    }

    func step() {
        let (programId, program) = programs.weightedRandomElement { p in p.value.score }
        let modification = modifications.randomElement()!
        let newProgram = modification.modify(programId, program, programs)
        let id = Arg()
        guard let new = newProgram else {
            prompt("Modification by \(modification.name) failed.")
            modification.unboost()
            program.unboost() // ??
            return
        }
        guard new.isValidProgram(global: Array(programs.keys)) else {
            print("Generated invalid program.")
            let printProgram = prompt("Print it anyways?") | force | affirmative ?? false
            if printProgram {
                print("Program P\(id)")
                print(new.stringify(global: programs))
            }
            return
        }
        print("New program has been invented by \(modification.name):")
        print(new.stringify(global: programs))
        let success = (prompt | force | affirmative)("Accept program?") ?? false
        guard success else {
            modification.unboost()
            program.unboost()
            print("Program rejected.")
            return
        }
        program.boost()
        modification.boost()
        let name = prompt("Please name this program.")!
        new.name = name
        programs[id] = new
        print("Program accepted.")
    }

}

func main() {
    let mather = Mather(
        programs: defaultPrograms,
        modifications: defaultModifications
    )
    while(true) { mather.step() }
}

main()

