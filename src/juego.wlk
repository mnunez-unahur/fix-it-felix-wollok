import wollok.game.*
import ralph.*
import ventana.*


object juego {
	var gameOver = false
	const stages = []
	var stage = 0
	
	var property vidas = 3
	var property dificultad = 1
	
	method preparar() {
		const stage1 = new Stage(fondo = "fondo/nivel-1.png")
		stage1.agregarMultiplesVentanas([
			[1,1], [2,1], [4,1], [5,1],
			[1,2], [2,2], [4,2], [5,2],
			[1,3], [2,3], [3,3], [4,3], [5,3]
		])

		const stage2 = new Stage(fondo = "fondo/nivel-2.png")
		stage2.agregarMultiplesVentanas([
			[1,1], [2,1], [3,1], [4,1], [5,1],
			[1,2], [2,2], [3,2], [4,2], [5,2],
			[1,3], [2,3], [3,3], [4,3], [5,3]
		])

		const stage3 = new Stage(fondo = "fondo/nivel-2.png")
		stage3.agregarMultiplesVentanas([
			[1,1], [2,1], [3,1], [4,1], [5,1],
			[1,2], [2,2], [3,2], [4,2], [5,2],
			[1,3], [2,3], [3,3], [4,3], [5,3]
		])
	
		stages.add(stage1)
		stages.add(stage2)
		stages.add(stage3)
		
		game.addVisual(ralph)
		
	}
	

	method stageActual() = stages.get(stage)
	method iniciar() {
		self.stageActual().iniciar()	
		game.start()	
	}
	
	method siguienteNivel() {
		self.stageActual().finalizar()
		stage++
		self.stageActual().iniciar()
		
		//TODO: cuando se finaliza el ultimo nivel se termina el juego
		
		
	}
}

class Stage {
	const fondo
	const ventanas = []
	const tablero = [
		[
			new Position(x = 30, y = 2),
			new Position(x = 39, y = 2),
			new Position(x = 48, y = 2),
			new Position(x = 57, y = 2),
			new Position(x = 66, y = 2)
		],
		[
			new Position(x = 30, y = 16),
			new Position(x = 39, y = 16),
			new Position(x = 48, y = 16),
			new Position(x = 57, y = 16),
			new Position(x = 66, y = 16)
		],
		[
			new Position(x = 30, y = 32),
			new Position(x = 39, y = 32),
			new Position(x = 48, y = 32),
			new Position(x = 57, y = 32),
			new Position(x = 66, y = 32)
		]
	]

	method esRangoValido(x, y) {
		return (x >= 1 and x <= 5) and (y >=1 and y <= 3)
	}

	// devuelve la posición absoluta de la coordinada del tablero
	// los valores válidos para x son 1 a 5
	// los valores válidos para y son 1 a 3 
	method posicionDeCoordenadas(x, y) {
		if(!self.esRangoValido(x, y)) {
			self.error("las coordenadas quedan fuera del tablero")
		}
		return tablero.get(y-1).get(x-1)
	}
	
	method agregarVentanaEn(x,y) {
		const ventana = new Ventana(position = self.posicionDeCoordenadas(x,y))
		
		ventanas.add(ventana)
	}
	
	method mostrarVentanas() {
		console.println("stage: " +  fondo)
		ventanas.forEach({v => game.addVisual(v)})		
	}
	
	//Oculta las ventanas del stage si están visibles
	method ocultarVentanas() {
		ventanas.forEach({v => if(game.hasVisual(v)) game.removeVisual(v)})		
	}

	
	// agrega múltiples ventanas en las coordinadas indicadas
	// lista es una lista de coordenadas [[x,y], [x,y]...]
	method agregarMultiplesVentanas(lista) {
		lista.forEach({ c => self.agregarVentanaEn(c.get(0), c.get(1))})
	}
	
	method iniciar() {
		console.println(fondo)		
	  	game.boardGround(fondo)
	  	self.mostrarVentanas()
		ralph.hacerRutina()
	}
	
	method finalizar() {
		self.ocultarVentanas()
		ralph.quedarseParado()
	}
	
}



