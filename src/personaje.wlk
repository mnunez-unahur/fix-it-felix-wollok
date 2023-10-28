import wollok.game.*
import elementos.*

import animacion.*

// un caracter es un elemento que puede ser insertado en el juego
// un caracter no necesariamente es visible
class Caracter {
	var position
	
	method position(nuevaPosicion) {
		position = nuevaPosicion
	}
	method position() = position
	
	method mostrar(){
		if(!game.hasVisual(self)) {
			game.addVisual(self)
		}
	}
	method ocultar(){
		if(game.hasVisual(self)) {
			game.removeVisual(self)		
		}
	}
	
}

// representa un objeto que tiene una representación
// visual en el juego
// es una clase abstracta ya que no implementa cómo se muestra el elemento 
class Visual inherits Caracter {
	// indica si ese objeto provoca daño cuando colisiona con felix
	const property haceDanio = false
	
	method image()
//	method image(nuevaImagen)
	
}

// representa un objeto Visual que no puede cambiar su posición inicial
// es útil para obstaculos
class Estatico inherits Visual {
	var image
	
	override method image() = image
	
	
	override method position(nuevaPosicion) {
		self.error("este elemento no puede ser reubicado")
	}
}


// Representa un objeto que Visual que puede transladarse
// de una celda a otra, pasando por las intermedias
class Transladable inherits Visual {
	var enMovimiento = false
	var property velocidad
	
	
	//genera un nombre único para el objeto
	// esto es utilizado por los eventos automaticos
	const nombreEventoMovimiento= "movimiento-personaje-" + 0.randomUpTo(100000)
	
	// Mueve a la coordenada indicada y luego ejecuta una acción
	// TODO: refactorizar
	method moverAPosicionyHacerAccion(x, y,accion) {
		if(enMovimiento) {
			self.detenerMovimiento()
		}
		
		enMovimiento = true
		
		game.onTick(1000 / velocidad, nombreEventoMovimiento , {
			
			// legué a mi destino
			if(self.coordenadaActualX() == x && self.coordenadaActualY() == y) {
				self.detenerMovimiento()
				accion.apply()
			}
			else {	
			self.position(new Position(x= self.coordenadaActualX() + self.diferenciaDePosicionX(x), y=self.coordenadaActualY() + self.diferenciaDePosicionY(y)))
				
			}
		})				
		
	}
	method moverAPosicion(x,y){
		self.moverAPosicionyHacerAccion(x,y,{})
	}
	method diferenciaDePosicionX(x){
		return if(self.coordenadaActualX() > x) - 1 
			else if(self.coordenadaActualX() < x) 1 
			else 0
	}
	method diferenciaDePosicionY(y){
		return if(self.coordenadaActualY() > y) - 1 
			else if(self.coordenadaActualY()  < y) 1 
			else 0
	}
	method coordenadaActualX(){
		return self.position().x()
	}
	method coordenadaActualY(){
		return self.position().y()
	}
	
	method detenerMovimiento() {
		if(enMovimiento) {
			enMovimiento = false
			game.removeTickEvent(nombreEventoMovimiento)			
		}
	}
}

// representa un objeto transladable sin animación
class Inanimado inherits Transladable{
	var property image
	
}

class Animado inherits Transladable {
	var animacion = nullAnimacion
	
	override method image() = animacion.image()
	
	// inicia la animación actual
	method animar() {
		animacion.iniciar()
	}

	//inicia una nueva animación	
	method animar(nuevaAnimacion) {
		if(nuevaAnimacion != animacion) {
			self.detenerAnimacion()		
			animacion = nuevaAnimacion
		}
		self.animar()
	}
	
	// detiene animación actual
	method detenerAnimacion() {
		animacion.detener()		
	}
	
	method resetearAnimacion() {
		animacion.detener()		
		animacion.resetear()
	}	
	method siguienteFotograma(){
		animacion.siguiente()
	}
	
	// indica si actualmente hay una animación en curso
	method animando() = animacion.animando()
	
}


