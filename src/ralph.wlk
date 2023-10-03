import wollok.game.*
import animacion.*

object ralph {
	const imagenBase = "ralph/pega-1.png"
	var animacion
	var text = ""
	const  animacionGolpeando = new Animacion(nombre = "ralph-golpeando", 
				  						velocidad=4,
  										fotogramas=["ralph/pega-1.png", "ralph/pega-2.png"]
  								)

	const  animacionCaminandoIzquierda = new Animacion(nombre = "ralph-camina-izquierda", 
				  						velocidad=4,
  										fotogramas=["ralph/camina-izquierda-1.png", "ralph/camina-izquierda-2.png"]
  								)


	const  animacionCaminandoDerecha = new Animacion(nombre = "ralph-camina-derecha", 
				  						velocidad=4,
  										fotogramas=["ralph/camina-derecha-1.png", "ralph/camina-derecha-2.png"]
  								)

	const  animacionSubiendo = new Animacion(nombre = "ralph-sube", 
				  						velocidad=4,
  										fotogramas=["ralph/sube-1.png", "ralph/sube-2.png"]
  								)

	const  animacionGritando = new Animacion(nombre = "ralph-grita", 
				  						velocidad=4,
  										fotogramas=["ralph/grita-1.png", "ralph/grita-2.png"]
  								)

	method position() = new Position(x=53, y=47)
	
	method text() = text
	
	method image() = if(animacion != null) animacion.image() else imagenBase
	
	method golpear() {
		text = ""
		if(animacion != null) {
			animacion.detener()
		}
		animacion = animacionGolpeando
		animacion.iniciar()
	}
	
	method caminarIzquierda() {
		text = ""
		if(animacion != null) {
			animacion.detener()
		}
		animacion = animacionCaminandoIzquierda
		animacion.iniciar()
	}

	method caminarDerecha() {
		text = ""
		if(animacion != null) {
			animacion.detener()
		}
		animacion = animacionCaminandoDerecha
		animacion.iniciar()
	}
	
	method subir() {
		text = ""
		if(animacion != null) {
			animacion.detener()
		}
		animacion = animacionSubiendo
		animacion.iniciar()
	}

	method gritar(texto) {
		if(animacion != null) {
			animacion.detener()
		}
		
		animacion = animacionGritando
		animacion.iniciar()
		text = texto
	}


}