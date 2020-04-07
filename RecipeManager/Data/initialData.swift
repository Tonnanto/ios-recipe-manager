//
//  initialData.swift
//  RecipeManager
//
//  Created by Anton Stamme on 13.03.20.
//  Copyright © 2020 Anton Stamme. All rights reserved.
//

import Foundation
import UIKit

var ingredientTypes: [IngredientType] = []
var recipes: [Recipe] = [] {
    didSet {
        print("recipes updated")
        NotificationCenter.default.post(name: Recipe.recipesUpdatedNotification, object: nil)
    }
}
var favouriteRecipes: [Recipe] {
    return recipes.filter({$0.isFavourite})
}
var customUnits: [UnitType] = []

extension Recipe {
    static func initializeRecipes() {
        
        
        let recipe1 = Recipe(name: "Salami, Jalapeño & Olive Pizza with Honey", images: [
                UIImage(named: "testRecipe1.1"),
                UIImage(named: "testRecipe1.2"),

            ], ingredients: [
                Ingredient(type: IngredientType(name: "Pizza Dough", unit: .weight(.pounds)), amount: 1),
                Ingredient(type: IngredientType(name: "Pizza Sauce", unit: .weight(.ounces)), amount: 14),
                Ingredient(type: IngredientType(name: "Mozzarella", unit: .weight(.ounces)), amount: 12),
                Ingredient(type: IngredientType(name: "Salami", unit: .amount(.slices)), amount: 20),
                Ingredient(type: IngredientType(name: "Red Onion", unit: .amount(.pieces)), amount: 0.25),
                Ingredient(type: IngredientType(name: "Jalapeño", unit: .amount(.pieces)), amount: 1),
                Ingredient(type: IngredientType(name: "Castelvetrano olives", unit: .volume(.cups)), amount: 0.5),
                Ingredient(type: IngredientType(name: "Olive oil", unit: .none), amount: 0),
                Ingredient(type: IngredientType(name: "Honey", unit: .volume(.cups)), amount: 0.25),
                Ingredient(type: IngredientType(name: "Red Pepper flakes", unit: .none), amount: 0),

            ], preperationSteps: [
                PreperationStep(text: "Heat oven to 500° F."),
                PreperationStep(text: "Let pizza dough come to room temperature for 30 minutes before rolling out onto a lightly !oured surface with a rolling pin."),
                PreperationStep(text: "When your dough is roughly 10 inches in diameter or 1⁄2 inch thick, place it on a lightly oiled baking sheet, pizza pan, or pre-heated pizza stone."),
                PreperationStep(text: "To make the everything bagel seasoning, mix all ingredients in a small bowl and set aside."),
                PreperationStep(text: "Spoon pizza sauce (to desired thin or thickness) onto dough leaving 1-inch of crust exposed around the edges. Cover the sauce with 3⁄4 of the mozzarella cheese."),
                PreperationStep(text: "Place the salami, onion, jalapeños, and olives onto the pizza. Sprinkle with remaining cheese."),
                PreperationStep(text: "Brush edges of pizza with olive oil and sprinkle with the everything bagel seasoning."),
                PreperationStep(text: "Place pizza in the oven for 10-12 minutes until edges are golden brown and the center of the crust is crispy."),
                PreperationStep(text: "Remove from oven, drizzle with honey and sprinkle with red pepper !akes. Serve with extra honey for dipping the crust into.")

            ], subRecipes: [
                SubRecipe(name: "Bagel Seasoning", index: 1, ingredients: [
                        Ingredient(type: IngredientType(name: "Poppy seeds", unit: .volume(.teaspoons)), amount: 2),
                        Ingredient(type: IngredientType(name: "Onion flakes", unit: .volume(.teaspoons)), amount: 2),
                        Ingredient(type: IngredientType(name: "Garlic flakes", unit: .volume(.teaspoons)), amount: 2),
                        Ingredient(type: IngredientType(name: "Sesame seeds", unit: .volume(.teaspoons)), amount: 2),
                        Ingredient(type: IngredientType(name: "Coarse salt", unit: .volume(.teaspoons)), amount: 0.5)
                    ]
                )
        ], infoTypes: [.serves(4), .prepTime(20), .cookTime(15), .ovenTemp(500, unit: "F")], categories: [.baking, .meal], tags: ["Bake", "Pizza"])


        let recipe2 = Recipe(name: "Fluffige Taler zum eintunken: Zucchinipuffer mit Feta und Tzatziki", images: [UIImage(named: "testRecipe2.1")], ingredients: [
            Ingredient(type: IngredientType(name: "Zucchini", unit: .weight(.grams)), amount: 450),
            Ingredient(type: IngredientType(name: "Feta", unit: .weight(.grams)), amount: 150),
            Ingredient(type: IngredientType(name: "Dill", unit: .amount(.custom("Bund"))), amount: 0.5),
            Ingredient(type: IngredientType(name: "Petersilie", unit: .amount(.custom("Bund"))), amount: 0.5),
            Ingredient(type: IngredientType(name: "Jalapeño", unit: .amount(.pieces)), amount: 1),
            Ingredient(type: IngredientType(name: "Ei", unit: .amount(.pieces)), amount: 1),
            Ingredient(type: IngredientType(name: "Mehl", unit: .weight(.grams)), amount: 30),
            Ingredient(type: IngredientType(name: "Salz & Pfeffer", unit: .none), amount: 0),
            Ingredient(type: IngredientType(name: "Öl", unit: .volume(.tablespoons)), amount: 2),
            Ingredient(type: IngredientType(name: "Tzatziki", unit: .weight(.grams)), amount: 200)

        ], preperationSteps: [
            PreperationStep(text: "Zucchini trimmen und raspeln. In ein Sieb geben und mit 1 EL Salz vermengen, ca. 5 Minuten ziehen lassen."),
            PreperationStep(text: "Feta zerkrümeln. Dill, Petersilie und Jalapeno hacken. Ei verquirlen"),
            PreperationStep(text: "Zucchiniraspeln mit den Händen ausdrücken und mit Feta, Kräutern, Jalapeno und Ei vermengen. Mehl nach und nach unterrühren und mit Salz und Pfeffer abschmecken."),
            PreperationStep(text: "Öl in einer Pfanne erhitzen. Einige Löffel Zucchinimasse in die Pfanne geben und zu Talern formen. Im heißen Öl 5-7 Minuten knusprig ausbacken, auf Küchenpapier abtropfen lassen. Mit Tzatziki servieren.")

        ], infoTypes: [.serves(4), .prepTime(15), .cookTime(10)], categories: [.cooking, .snack], tags: [])


        let recipe3 = Recipe(name: "Bircher Müsli", images: [], ingredients: [
            Ingredient(type: IngredientType(name: "Haferflocken", unit: .weight(.grams)), amount: 150),
            Ingredient(type: IngredientType(name: "Sahne", unit: .weight(.grams)), amount: 200),
            Ingredient(type: IngredientType(name: "Milch", unit: .weight(.grams)), amount: 200),
            Ingredient(type: IngredientType(name: "Agaven Sirup oder Honig", unit: .weight(.grams)), amount: 60),
            Ingredient(type: IngredientType(name: "Naturjoghurt", unit: .weight(.grams)), amount: 150),
            Ingredient(type: IngredientType(name: "6-Korn-Mischung", unit: .weight(.grams)), amount: 80),
            Ingredient(type: IngredientType(name: "Mandeln", unit: .weight(.grams)), amount: 60),
            Ingredient(type: IngredientType(name: "Apfel", unit: .amount(.pieces)), amount: 1),
            Ingredient(type: IngredientType(name: "Banane", unit: .amount(.pieces)), amount: 2)

        ], preperationSteps: [
            PreperationStep(text: "Haferflocken mit Sahne, Milch, Agaven Sirup und Naturjoghurt mischen und über Nacht zugedeckt ziehen lassen."),
            PreperationStep(text: "6-Korn-Mischung in den Thermomix geben und 20 Sekunden/Stufe 7 schroten. Mit kaltem Wasser bedeckt im Mixtopf über Nacht ziehen lassen."),
            PreperationStep(text: "Morgens Mandeln zu den geschroteten Körnern geben und 3 Sekunden/Stufe 6 zerkleinern."),
            PreperationStep(text: "Apfel und Bananen zugeben und 3 Sekunden/Stufe 5."),
            PreperationStep(text: "Zum Schluss die Haferflocken-Mischung dazugeben und 15 Sekunden/Linkslauf/Stufe 3 mischen.")

        ], infoTypes: [.serves(6), .prepTime(10)], categories: [.snack, .thermomix], tags: ["Thermomix", "Müsli", "Obst"])

        let recipe4 = Recipe(name: "Beste Moussaka", images: [UIImage(named: "testRecipe4.1"), UIImage(named: "testRecipe4.2")], ingredients: [
            Ingredient(type: IngredientType(name: "Hackfleisch, gemischt", unit: .weight(.grams)), amount: 500),
            Ingredient(type: IngredientType(name: "Auberginen", unit: .amount(.pieces)), amount: 2),
            Ingredient(type: IngredientType(name: "Zucchini", unit: .amount(.pieces)), amount: 2),
            Ingredient(type: IngredientType(name: "Karotten", unit: .amount(.pieces)), amount: 2),
            Ingredient(type: IngredientType(name: "Zwiebel", unit: .amount(.pieces)), amount: 2),
            Ingredient(type: IngredientType(name: "geschläte Tomaten", unit: .amount(.custom("Dose"))), amount: 1),
            Ingredient(type: IngredientType(name: "Knoblauch", unit: .amount(.custom("Zehen"))), amount: 3),
            Ingredient(type: IngredientType(name: "Kreuzkümmel", unit: .volume(.teaspoons)), amount: 0.5),
            Ingredient(type: IngredientType(name: "Paprikapulver, mild", unit: .volume(.teaspoons)), amount: 1),
            Ingredient(type: IngredientType(name: "Gemüsebrühe", unit: .volume(.tablespoons)), amount: 2),
            Ingredient(type: IngredientType(name: "Salz", unit: .none), amount: 0),
            Ingredient(type: IngredientType(name: "Pfeffer, dunkel", unit: .none), amount: 0),
            Ingredient(type: IngredientType(name: "Muskatnuss, frisch gerieben", unit: .sprinkle), amount: 1),
            Ingredient(type: IngredientType(name: "Mozzarella", unit: .weight(.grams)), amount: 250),
            Ingredient(type: IngredientType(name: "Magerquark", unit: .weight(.grams)), amount: 250),
            Ingredient(type: IngredientType(name: "Oregano", unit: .volume(.tablespoons)), amount: 1),
            Ingredient(type: IngredientType(name: "Eier", unit: .amount(.pieces)), amount: 3),
            Ingredient(type: IngredientType(name: "Olivenöl", unit: .none), amount: 0),
            Ingredient(type: IngredientType(name: "Milch", unit: .volume(.millilitres)), amount: 150),

        ], preperationSteps: [
            PreperationStep(text: "Die Auberginen und die Zucchini in ca 0,5 cm dicke Scheiben schneiden, mit Salz bestreuen und ca 20 - 30 Minuten Flüssigkeit entziehen lassen."),
            PreperationStep(text: "Währenddessen das Hackfleisch mit Olivenöl krümelig braten. Dann die klein geschnittenen Karotten, Zwiebeln und Knoblauch hinzugeben und ca. 2 Minuten mitbraten. Danach Kreuzkümmel, Paprikapulver, 1 EL Gemüsebrühe, Oregano und Pfeffer dazugeben und alles gut miteinander vermischen. Mit geschlossenem Deckel ca. 2 Minuten weiter dünsten. Danach die geschälten Tomaten samt Saft hinzugeben und mit einem Küchenhelfer in der Pfanne zerstückeln. Dann nochmals ca 3 - 4 Minuten weiter dünsten. Die Pfanne mit geschlossenem Deckel beiseite stellen und die Gewürze einziehen lassen."),
            PreperationStep(text: "Nun den Backofen auf 180 Grad vorheizen (Umluft ca 160-170 Grad)."),
            PreperationStep(text: "Die Auberginen und Zucchini portionsweise in einer Pfanne ohne Öl anbraten. Dabei die Scheiben mit einem Pinsel leicht mit Olivenöl bepinseln. Die Scheiben wenden und danach auf Küchenpapier abtropfen lassen."),
            PreperationStep(text: "In einer Schüssel die 3 Eier, 1 EL Gemüsebrühe, 150 ml Milch sowie 500 g Quark verrühren, bis eine klumpenfreie Flüssigkeit entsteht."),
            PreperationStep(text: "In einem tiefen Bräter den Boden mit der Hälfte der Auberginen und Zucchini belegen. Danach das Hackfleisch, darüber die klein gewürfelten Mozzarellascheiben und darüber ca 2/3 der Eier-Quark-Milch-Flüssigkeit verteilen, mit Muskat und Pfeffer würzen. Diesen Vorgang mit einer weiteren Lage wiederholen und den Bräter für 45 Minuten in den Backofen geben."),
            PreperationStep(text: "Nach Ende der Backzeit 5 Minuten abkühlen lassen. Aufschneiden, servieren und genießen.")

        ], infoTypes: [.serves(4), .prepTime(40), .cookTime(45), .ovenTemp(165, unit: "C")], categories: [.cooking, .baking, .meal], tags: [])

        let recipe5 = Recipe(name: "Türkischer Brotschmaus", images: [], ingredients: [
            Ingredient(type: IngredientType(name: "Knoblauch", unit: .amount(.custom("Zehe"))), amount: 1),
            Ingredient(type: IngredientType(name: "Petersilie", unit: .amount(.custom("Handvoll"))), amount: 1),
            Ingredient(type: IngredientType(name: "Schafskäse", unit: .weight(.grams)), amount: 100),
            Ingredient(type: IngredientType(name: "Ajvar", unit: .weight(.grams)), amount: 100),
            Ingredient(type: IngredientType(name: "Frischkäse", unit: .weight(.grams)), amount: 200)

        ], preperationSteps: [
            PreperationStep(text: "Knoblauch und Petersilie 8 Sek./ Stufe 5"),
            PreperationStep(text: "Schafskäse dazu und 10 Sek./ Stufe 4"),
            PreperationStep(text: "Ajvar und Frischkäse dazu und 10 Sek./ Stufe 4"),

        ], subRecipes: [], infoTypes: [.serves(4), .prepTime(5)], categories: [.sauce, .thermomix], tags: [])

        CloudKitService.uploadRecipe(recipe: recipe1) { (bool, record) in
            if bool { print("Successfully uploaded Recipe1") }
        }
        
        CloudKitService.uploadRecipe(recipe: recipe2) { (bool, record) in
            if bool { print("Successfully uploaded Recipe2") }
        }
        
        CloudKitService.uploadRecipe(recipe: recipe3) { (bool, record) in
            if bool { print("Successfully uploaded Recipe3") }
        }
        
        CloudKitService.uploadRecipe(recipe: recipe4) { (bool, record) in
            if bool { print("Successfully uploaded Recipe4") }
        }
        
        CloudKitService.uploadRecipe(recipe: recipe5) { (bool, record) in
            if bool { print("Successfully uploaded Recipe5") }
        }
        
        PersistenceService.saveContext()
    }
}
