import wollok.game.*
import personaje.*
import animacion.*
/*
 * posiciones donde se detiene ralph
 * 25
 * 34
 * 43
 * 52
 * 61
 */
 
 
object ralph inherits Personaje(nombre="ralph",
								animacion=new Animacion(nombre = "ralph-parado", 
				  										velocidad=0,
  														fotogramas=["ralph/parado.png"]
  														), 
  								position=new Position(y=47, x=43)) {
  									
  									
//	const limiteIzquierdo = 25
//	const limiteDerecho = 61
	const fila = 47
	const distanciaEntreVentana = 9
	var caminandoALaIzquierda = true
	
	const  animacionParado = new Animacion(nombre = "ralph-parado", 
				  						velocidad=0,
  										fotogramas=["ralph/parado.png"]
  								)
  
  
	const  animacionGolpeando = new Animacion(nombre = "ralph-golpeando", 
				  						velocidad=6,
  										fotogramas=["ralph/pega-1.png", "ralph/pega-2.png"]
  								)

	const  animacionCaminandoIzquierda = new Animacion(nombre = "ralph-camina-izquierda", 
				  						velocidad=5,
  										fotogramas=["ralph/camina-izquierda-1.png", "ralph/camina-izquierda-2.png"]
  								)


	const  animacionCaminandoDerecha = new Animacion(nombre = "ralph-camina-derecha", 
				  						velocidad=5,
  										fotogramas=["ralph/camina-derecha-1.png", "ralph/camina-derecha-2.png"]
  								)

	const  animacionSubiendo = new Animacion(nombre = "ralph-sube", 
				  						velocidad=2,
  										fotogramas=["ralph/sube-1.png", "ralph/sube-2.png"]
  								)

	const  animacionGritando = new Animacion(nombre = "ralph-grita", 
				  						velocidad=4,
  										fotogramas=["ralph/grita-1.png", "ralph/grita-2.png"]
  								)

	method golpear() {
		self.detenerMovimiento()
		self.animar(animacionGolpeando)
		// TODO: agregar ladrillo al tablero
	}
	
	// mueve a la posicion x especificada y ejecuta una accion al llegar
	method caminarAPosicionXyEjecutar(x, accion) {
		self.detenerMovimiento()
		const nuevaAnimacion = if(x < position.x()) animacionCaminandoIzquierda else  animacionCaminandoDerecha
		self.animar(nuevaAnimacion)
		self.moverAPosicionyHacerAccion(x, fila, 20, accion)		
	}
	
	method quedarseParado() {
		self.detenerMovimiento()
		self.animar(animacionParado)
	}
	
	method subir() {
		self.detenerMovimiento()
		self.animar(animacionSubiendo)
		self.moverAPosicionyHacerAccion(position.x(), 61, 20, {self.quedarseParado()})
	}

	method gritar(texto) {
		self.detenerMovimiento()
		self.animar(animacionGritando)
		self.hablar(texto)
	}
	
	// este método hace que cada vez que llega a una ventana
	// Ralph decida que hacer:
	// - protestar
	// - golpear el piso
	method hacerRutina() {
 		// TODO: mejorar mecanismo de decisión
		if(0.randomUpTo(2) < 1) 
			self.golpear() 
		else 
			self.gritar("")
			
		game.schedule(1500, { 
			caminandoALaIzquierda = (not caminandoALaIzquierda and position.x() >= 61) 
									or (caminandoALaIzquierda and position.x()>25)
			const direccion = if(caminandoALaIzquierda) -1 else 1
			const nuevaPosicionX = position.x() + distanciaEntreVentana * direccion
			self.caminarAPosicionXyEjecutar(nuevaPosicionX, {self.hacerRutina()})
			
		})
	}
	
	


}