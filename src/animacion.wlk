import wollok.game.*

class Animacion {
	
	// el nombre es requerido para poder deterner el evento automático
	const property nombreAnimacion = "animacion_" + 0.randomUpTo(999999).toString()
	const fotogramas = []
	//velocidad en fotogramas por segundo
	var property velocidad = 0
	var fotogramaActual = 0
	var animando = false
	
	method agregarFotograma(img) {
		fotogramas.add(img)
	}
	
	method image() = if(fotogramas.isEmpty()) "" else fotogramas.get(fotogramaActual)
	
	
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
		if(velocidad != 0) {
			animando = true
			game.onTick(1000 / velocidad, nombreAnimacion, { self.siguiente() })				
		}
	}
	
	method detener() {
		if(animando) {
			animando = false
			game.removeTickEvent(nombreAnimacion)			
		}
	}
	
	method irAFotograma(numeroFotograma) {
		fotogramaActual = numeroFotograma
	}
	
	
}
class Visual {
	var property image
	
	method position() = game.at(0,0)
	method mostrar(){ game.addVisual(self) }
}
const inicio = new Visual(image = "fondo/Captura4.JPG")
const imagen33 = new Visual(image= "fondo/stage1.png")