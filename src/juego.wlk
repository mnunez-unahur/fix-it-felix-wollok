import wollok.game.*
import ralph.*
import animacion.*
import Elementos.*

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
	
	  	game.boardGround("fondo/nivel-1.png")
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

// representa una celda del tablero
// cada celda puede contener o no ventana
class Celda{
	var ventana = null
	var property position
	var property tieneLadrillo = false
	var property estaFelix = false
	
	method ventana() = ventana
	method agregarVentana() {
		ventana = new Ventana(position = position)
	}
	method tieneVentana() = ventana != null
	
}

class Tablero {
	// la grilla representa las posisiones válidas del tablero
	const grilla = [
		[
			new Celda(position = new Position(x = 30, y = 2)),
			new Celda(position = new Position(x = 39, y = 2)),
			new Celda(position = new Position(x = 48, y = 2)),
			new Celda(position = new Position(x = 57, y = 2)),
			new Celda(position = new Position(x = 66, y = 2))
		],
		[
			new Celda(position = new Position(x = 30, y = 16)),
			new Celda(position = new Position(x = 39, y = 16)),
			new Celda(position = new Position(x = 48, y = 16)),
			new Celda(position = new Position(x = 57, y = 16)),
			new Celda(position = new Position(x = 66, y = 16))
		],
		[
			new Celda(position = new Position(x = 30, y = 32)),
			new Celda(position = new Position(x = 39, y = 32)),
			new Celda(position = new Position(x = 48, y = 32)),
			new Celda(position = new Position(x = 57, y = 32)),
			new Celda(position = new Position(x = 66, y = 32))
		]
	]
	
	method esRangoValido(x, y) {
		return (x >= 1 and x <= grilla.get(0).size()) and (y >=1 and y <= grilla.size())
	}
	
	// devuelve la celda ubicada en la posición indicada del tablero
	method celdaEn(x, y) {
		if(!self.esRangoValido(x, y)) {
			self.error("las coordenadas quedan fuera del tablero")
		}
		return grilla.get(y-1).get(x-1)		
	}
	
	// devuelve la posición absoluta de la coordinada del tablero
	method posicionDeCoordenadas(x, y) = self.celdaEn(x, y).position()
	
	method celdasConVentanas() = grilla.flatten().filter({c => c.ventana() != null})
	
	// devuelve la lista de ventanas del tablero
	method ventanas() {
		return self.celdasConVentanas().map({v => v.ventana()})		
	}
	
	method mostrarVentanas() {
		self.ventanas().forEach({v => game.addVisual(v)})		
	}
	
	//Oculta las ventanas del stage si están visibles
	method ocultarVentanas() {
		self.ventanas().forEach({v => if(game.hasVisual(v)) game.removeVisual(v)})		
	}
	
	//muestra los componentes del tablero
	method mostrar() {
		self.mostrarVentanas()
	}
}

class Stage {
	const fondo
	
	const tablero = new Tablero()
	
	// agrega una ventana en la celda x y del tablero
	method agregarVentanaEn(x,y) {
		tablero.celdaEn(x, y).agregarVentana()
		
	}
	
	// agrega múltiples ventanas en las coordinadas indicadas
	// lista es una lista de coordenadas [[x,y], [x,y]...]
	method agregarMultiplesVentanas(lista) {
		lista.forEach({ c => self.agregarVentanaEn(c.get(0), c.get(1))})
	}
	
	method iniciar() {
	  	tablero.mostrar()
		ralph.hacerRutina()
	}
	
	method finalizar() {
//		self.ocultar()
//		ralph.quedarseParado()
	}
	
}



