import wollok.game.*

import animacion.*


class Personaje {
	var nombre
	
	var animacion 
	var property position
//	var destino = new Position(x=0, y=0)
	var text = ""
	var enMovimiento = false


	method image() = animacion.image()


	// inicia la animación actual
	method animar() {
		animacion.iniciar()
	}

	//inicia una nueva animación	
	method animar(nuevaAnimacion) {
		self.detenerAnimacion()
		animacion = nuevaAnimacion
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
	
	
	method hablar(mensaje) {
		text = mensaje
	}
	
	method callar() {
		text = ""
	}

	method text() = text
	
	method nombreEventoMovimiento() = "movimiento-personaje-" + nombre
	
	// Mueve a la coordenada indicada y luego ejecuta una acción
	// TODO: refactorizar
	method moverAPosicionyHacerAccion(x, y, velocidad, accion) {
		if(enMovimiento) {
			self.detenerMovimiento()
		}
		
		enMovimiento = true
		
		game.onTick(1000 / velocidad, self.nombreEventoMovimiento() , {
			
			// legué a mi destino
			if(position.x() == x && position.y() == y) {
				self.detenerMovimiento()
				accion.apply()
			}
			else {
			const posX = position.x() + if(position.x() > x) -1 else if(position.x() < x) 1 else 0
			const posY = position.y() + if(position.y() > y) -1 else if(position.y() < y) 1 else 0
			
			position = new Position(x=posX, y=posY)
				
			}
		})				
		
	}
	
	method detenerMovimiento() {
		if(enMovimiento) {
			enMovimiento = false
			game.removeTickEvent(self.nombreEventoMovimiento())			
		}
	}
	
	
	
	
}
