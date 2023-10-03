import wollok.game.*

class Animacion {
	
	// el nombre es requerido para poder deterner el evento automático
	const property nombre
	const fotogramas = []
	//velocidad en fotogramas por segundo
	var property velocidad = 0
	var fotogramaActual = 0
	
	method agregarFotograma(img) {
		fotogramas.add(img)
	}
	
	method image() = if(fotogramas.isEmpty()) "" else fotogramas.get(fotogramaActual)
	
	method nombreAnimacion() = "animacion_" + nombre
	
	// reinicia la secuencia de la animación
	method resetear()  {
		fotogramaActual = 0
	}
	
	// establece el siguiente fotograma
	method siguiente() {
		// solo muevo al siguiente fotograma si hay alguno
		if(!fotogramas.isEmpty()) {
			fotogramaActual = (fotogramaActual + 1) % fotogramas.size()
		}		
	}
	
	// Inicia la animación
	method iniciar() {
		self.resetear()
		if(velocidad != 0) {
			game.onTick(1000 / velocidad, self.nombreAnimacion(), { self.siguiente() })				
		}
	}
	
	method detener() {
		game.removeTickEvent(self.nombreAnimacion())
	}
	
	
}