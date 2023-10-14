import wollok.game.*
import ralph.*
import animacion.*
import Elementos.*
import felix.*

object juego {
//	var gameOver = false
	const stages = []
	var stage = 0
	
	var property vidas = 3
	var property dificultad = 1
	var iniciado  = false
	
	method stageActual() = stages.get(stage)
	method tableroActual() = self.stageActual().tablero()
	method celdaActiva() = self.tableroActual().celdaActiva()

	method iniciar() {
		self.configurarVisual()
		self.configurarTeclas()
		self.configurarStages()
		self.mostrarImagenesIniciales()
		game.start()
	}


	method configurarStages() {
		const stage1 = new Stage(fondo = new Edificio(image="niveles/edificio-1.png"), 
								 imgInicial = new Pantalla (image ="fondo/stage1.png"))
		
		stage1.agregarMultiplesVentanas([
			[1,1], [2,1], [4,1], [5,1],
			[1,2], [2,2], [4,2], [5,2],
			[1,3], [2,3], [3,3], [4,3], [5,3]
		])

		const stage2 = new Stage(fondo = new Edificio(image="niveles/edificio-2.png"),
								 imgInicial = new Pantalla (image = "fondo/stage2.png")
		)
		stage2.agregarMultiplesVentanas([
			[1,1], [2,1], [3,1], [4,1], [5,1],
			[1,2], [2,2], [3,2], [4,2], [5,2],
			[1,3], [2,3], [3,3], [4,3], [5,3]
		])

		const stage3 = new Stage(fondo = new Edificio(image="niveles/edificio-2.png"),
								 imgInicial = new Pantalla (image = "fondo/stage2.png")
		)
		stage3.agregarMultiplesVentanas([
			[1,1], [2,1], [3,1], [4,1], [5,1],
			[1,2], [2,2], [3,2], [4,2], [5,2],
			[1,3], [2,3], [3,3], [4,3], [5,3]
		])

		const stage4 = new Stage(fondo = new Edificio(image="niveles/edificio-2.png"),
								 imgInicial = new Pantalla (image = "fondo/stage2.png")
		)
		stage4.agregarMultiplesVentanas([
			[1,1], [2,1], [3,1], [4,1], [5,1],
			[1,2], [2,2], [3,2], [4,2], [5,2],
			[1,3], [2,3], [3,3], [4,3], [5,3]
		])

		const stage5 = new Stage(fondo = new Edificio(image="niveles/edificio-2.png"),
								 imgInicial = new Pantalla (image = "fondo/stage2.png")
		)
		stage5.agregarMultiplesVentanas([
			[1,1], [2,1], [3,1], [4,1], [5,1],
			[1,2], [2,2], [3,2], [4,2], [5,2],
			[1,3], [2,3], [3,3], [4,3], [5,3]
		])

		stages.add(stage1)
		stages.add(stage2)
		stages.add(stage3)
		stages.add(stage4)
		stages.add(stage5)
		
	}
	
	method configurarTeclas() {
		keyboard.q().onPressDo({
			if(!felix.saltando() && self.celdaActiva().tieneVentana()) {
				felix.reparar(self.celdaActiva().ventana());
				
				// espero a que la ventana esté reparada
				// esto es porque por un tema de animación felix tarda 200 ms en reparar la ventana
				game.schedule(300,{
					if(self.tableroActual().cantidadVentanasRotas() == 0) {
						self.siguienteNivel()
					}			
				})	  			
				
			}
		})
		keyboard.right().onPressDo({
			if(!felix.saltando()) {
				felix.moverA(self.tableroActual().right().position().x(),felix.coordenadaActualY())
			}
		})
		keyboard.left().onPressDo({
			if(!felix.saltando()) {
				felix.moverA(self.tableroActual().left().position().x(),felix.coordenadaActualY())	
			}
		})
		
		keyboard.up().onPressDo({
			if(!felix.saltando()) {
				felix.moverA(felix.coordenadaActualX(), self.tableroActual().up().position().y())
			}
		})
		
		keyboard.down().onPressDo({
			if(!felix.saltando()) {
				felix.moverA(felix.coordenadaActualX(), self.tableroActual().down().position().y())
			}
		})	
		
	}
	
	method configurarVisual(){
		game.title("Fix It Felix Jr!")
		game.width(100)
		game.height(60)
		game.cellSize(10)
	  	game.boardGround("fondo.png")
		vida.mostrar()
		
		// pongo un par de nubes
		const nube1 = new Nube(position = new Position(x=-20, y=40))
		nube1.mostrar()
		nube1.mover()
		
		const nube2 = new Nube(position = new Position(x=-20, y=20), velocidad=10)
		nube2.mostrar()
		nube2.mover()			

		
	}
	
	method mostrarImagenesIniciales(){
		const inicio = new Pantalla(image = "fondo/Captura4.JPG")
		inicio.mostrar()
		keyboard.enter().onPressDo({
			if(!iniciado){
				inicio.ocultar();
			   	self.stageActual().iniciar()
			   	iniciado = true
		   	}
	   	})
									
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
	const property position
	const property posicionRelativa
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
		new Celda(position = new Position(x = 30, y = 2), posicionRelativa = new Position(x=1, y=1)),
		new Celda(position = new Position(x = 39, y = 2), posicionRelativa = new Position(x=2, y=1)),
		new Celda(position = new Position(x = 48, y = 2), posicionRelativa = new Position(x=3, y=1)),
		new Celda(position = new Position(x = 57, y = 2), posicionRelativa = new Position(x=4, y=1)),
		new Celda(position = new Position(x = 66, y = 2), posicionRelativa = new Position(x=5, y=1)),
		new Celda(position = new Position(x = 30, y = 16), posicionRelativa = new Position(x=1, y=2)),
		new Celda(position = new Position(x = 39, y = 16), posicionRelativa = new Position(x=2, y=2)),
		new Celda(position = new Position(x = 48, y = 16), posicionRelativa = new Position(x=3, y=2)),
		new Celda(position = new Position(x = 57, y = 16), posicionRelativa = new Position(x=4, y=2)),
		new Celda(position = new Position(x = 66, y = 16), posicionRelativa = new Position(x=5, y=2)),
		new Celda(position = new Position(x = 30, y = 32), posicionRelativa = new Position(x=1, y=3)),
		new Celda(position = new Position(x = 39, y = 32), posicionRelativa = new Position(x=2, y=3)),
		new Celda(position = new Position(x = 48, y = 32), posicionRelativa = new Position(x=3, y=3)),
		new Celda(position = new Position(x = 57, y = 32), posicionRelativa = new Position(x=4, y=3)),
		new Celda(position = new Position(x = 66, y = 32), posicionRelativa = new Position(x=5, y=3))
	]
	
	
	method esRangoValido(x, y) {
		return grilla.any({c => c.posicionRelativa().x() == x && c.posicionRelativa().y() == y})
	}
	
	// dada una coordenada válida del tablero, devuelve la celda de dicha coordenada
	// x e y son las posiciones relativas de la celda
	method celda(x, y) {
		if(!self.esRangoValido(x, y)) {
			self.error("las coordenadas quedan fuera del tablero")
		}
		return grilla.find({c => c.posicionRelativa().x() == x && c.posicionRelativa().y() == y})
	}
	
	//devuelve la posicion Absoluta de la celda especificada
	// x e y son las posiciones relativas de la celda
//	method posicionAbsolutaDeCelda(x, y) = self.celda(x, y).position()
	
	method celdasConVentanas() = grilla.filter({c => c.ventana() != null})
	
	// devuelve la lista de ventanas del tablero
	method ventanas() {
		return self.celdasConVentanas().map({v => v.ventana()})		
	}
	
	method mostrarVentanas() {
		self.ventanas().forEach({v => game.addVisual(v)})		
	}
	
	method cantidadVentanasRotas() {
		return self.ventanas().count({v => v.salud() < 2})
	}
	
	//Oculta las ventanas del stage si están visibles
	method ocultarVentanas() {
		self.ventanas().forEach({v => if(game.hasVisual(v)) v.mostrar()})		
	}
	
	// agrega sensores en las celdas para detectar si felix ingresa
	method agregarSensores() {
		
	}
	
	//muestra los componentes del tablero
	method mostrar() {
		self.mostrarVentanas()
	}
	
	// indica la celda en la cual se encuentra felix
	method celdaActiva() {
		return grilla.find({c => self.estaFelixAca(c.position().x(), c.position().y())})
	}
	
	// indica si en la posicion absoluta actual se encuentra felix
	method estaFelixAca(x, y) {
//		console.println("x: " + x + " y: " + y)
		return x == felix.coordenadaActualX() && y == felix.coordenadaActualY()
	}
	
	// indica cual es la útima fila (relativa) del tablero
	method ultimaFila() {
		return grilla.max({c => c.posicionRelativa().y()})
	}
	
	// indica cual es la útima columna (relativa) del tablero
	method ultimaColumna() {
		return grilla.max({c => c.posicionRelativa().x()})
	}
	
	method esPrimeraColumna(celda) {
		return celda.posicionRelativa().x() == 1
	}

	method esPrimeraFila(celda) {
		return celda.posicionRelativa().y() == 1
	}

	method esUltimaColumna(celda) {
		return celda.position().x() == self.ultimaColumna().position().x()
	}

	method esUltimaFila(celda) {
		return celda.position().y() == self.ultimaFila().position().y()
	}

	// devuelve la celda a la izquierda de la actual
	// si la celda actual es la primera, la devuelve
	method left() {
		if(self.esPrimeraColumna(self.celdaActiva())) {
			return self.celdaActiva()
		} else {
			return grilla.find({c => c.posicionRelativa().x() == self.celdaActiva().posicionRelativa().x() - 1})
		}
	}

	// devuelve la celda a la derecha de la actual
	// si la celda actual es la ultima, la devuelve
	method right() {
		if(self.esUltimaColumna(self.celdaActiva())) {
			return self.celdaActiva()
		} else {
			return grilla.find({c => c.posicionRelativa().x() == self.celdaActiva().posicionRelativa().x() + 1})
		}
	}

	// devuelve la celda que esta arriba de la actual
	// si la celda actual es la ultima, la devuelve
	method up() {
		if(self.esUltimaFila(self.celdaActiva())) {
			return self.celdaActiva()
		} else {
			return grilla.find({c => c.posicionRelativa().y() == self.celdaActiva().posicionRelativa().y() + 1})
		}
	}

	// devuelve la celda que esta abajo de la actual
	// si la celda actual es la primera, la devuelve
	method down() {
		if(self.esPrimeraFila(self.celdaActiva())) {
			return self.celdaActiva()
		} else {
			return grilla.find({c => c.posicionRelativa().y() == self.celdaActiva().posicionRelativa().y() - 1})
		}
	}

	
}

class Stage {
	const fondo
	const imgInicial
	
	const tablero = new Tablero()
	
	// agrega una ventana en la celda x y del tablero
	method agregarVentanaEn(x,y) {
		tablero.celda(x, y).agregarVentana()
		
	}
	method tablero() = tablero
	method mostrar(){ 
		game.addVisual(fondo)
		ralph.mostrar()
	  	tablero.mostrar()
	  	felix.mostrar()
	    imgInicial.mostrar()
	  	game.schedule(4000,{
	  						imgInicial.ocultar();
	  						ralph.hacerRutina()
	  	})
	  	
	}
	
	method ocultar() {
		game.removeVisual(fondo)
		ralph.ocultar()
		felix.ocultar()
		
	}
	
	
	// agrega múltiples ventanas en las coordinadas indicadas
	// lista es una lista de coordenadas [[x,y], [x,y]...]
	method agregarMultiplesVentanas(lista) {
		lista.forEach({ c => self.agregarVentanaEn(c.get(0), c.get(1))})
	}
	
	method iniciar() {	
	  	self.mostrar()

	}
	
	method finalizar() {
		ralph.finalizarRutina()
		felix.position(tablero.celda(1,1).position())
		
		self.ocultar()
	}
	
}

