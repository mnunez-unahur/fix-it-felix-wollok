import wollok.game.*
import animacion.*

object ralph {
	const imagenBase = "ralph/pega-1.png"
	var animacion
	var text = ""
	var property animacionGolpeando
	var property animacionCaminandoIzquierda
	var property animacionCaminandoDerecha
	var property animacionSubiendo
	var property animacionGritando

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