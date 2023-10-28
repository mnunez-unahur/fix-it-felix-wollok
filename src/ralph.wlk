import wollok.game.*
import personaje.*
import animacion.*
import elementos.*
import juego.*

/*
 * posiciones donde se detiene ralph
 * 25
 * 34
 * 43
 * 52
 * 61
 */
 
 
object ralph inherits Animado ( position=new Position(y=47, x=43),
  								velocidad = 20 ) {
  									
	const fila = 47 // solo se mueve en la fila 47
	const distanciaEntreVentana = 9
	var caminandoALaIzquierda = true
	var detenido = true
	var property stage = nullStage
	
	const  animacionParado = new Animacion( 
				  						velocidad=0,
  										fotogramas=["ralph/parado.png"]
  								)
  
  
	const  animacionGolpeando = new Animacion( 
				  						velocidad=6,
  										fotogramas=["ralph/pega-1.png", "ralph/pega-2.png"]
  								)

	const  animacionCaminandoIzquierda = new Animacion( 
				  						velocidad=5,
  										fotogramas=["ralph/camina-izquierda-1.png", "ralph/camina-izquierda-2.png"]
  								)


	const  animacionCaminandoDerecha = new Animacion( 
				  						velocidad=5,
  										fotogramas=["ralph/camina-derecha-1.png", "ralph/camina-derecha-2.png"]
  								)

	const  animacionSubiendo = new Animacion( 
				  						velocidad=2,
  										fotogramas=["ralph/sube-1.png", "ralph/sube-2.png"]
  								)

	const  animacionGritando = new Animacion( 
				  						velocidad=4,
  										fotogramas=["ralph/grita-1.png", "ralph/grita-2.png"]
  								)


	method golpear() {
		self.detenerMovimiento()
		self.animar(animacionGolpeando)
		golpe.reproducir()
		self.ladrilloSeCae()
		
	}
	
	method dificultad() = stage.dificultad()
	
	// la velocidad de ralph varía con la dificultad del juego
	override method velocidad() = super() + self.dificultad() * 3
	
	// crea un nuevo ladrillo que cae desde el techo
	// la velocidad de caída del ladrillo depende de la dificultad del stage
	method ladrilloSeCae(){ //ver como poner un objeto en la posicion x e y 
		const ladrillo = new Ladrillo (position = new Position(x = self.coordenadaActualX() + 5,
															   y = self.coordenadaActualY() - 2),
									   velocidad = 12 + self.dificultad()*2,
									   haceDanio = true)
		
										
		ladrillo.agregarAlJuego()
		ladrillo.caer()

		
	}
	
	
	// mueve a la posicion x especificada y ejecuta una accion al llegar
	method caminarAPosicionXyEjecutar(x, accion) {
		self.detenerMovimiento()
		const nuevaAnimacion = if(x < self.coordenadaActualX()) animacionCaminandoIzquierda else  animacionCaminandoDerecha
		self.animar(nuevaAnimacion)
		self.moverAPosicionyHacerAccion(x, fila, accion)		
	}
	
	method quedarseParado() {
		self.detenerMovimiento()
		self.animar(animacionParado)
	}
	
	method subir() {
		self.detenerMovimiento()
		self.animar(animacionSubiendo)
		self.moverAPosicionyHacerAccion(self.coordenadaActualX(), 61, {self.quedarseParado()})
	}

	method gritar() {
		self.detenerMovimiento()
		self.animar(animacionGritando)

	}
	
	// este método hace que cada vez que llega a una ventana
	// Ralph decida que hacer:
	// - protestar
	// - golpear el piso
	method hacerRutina() {
 		// TODO: mejorar mecanismo de decisión
		if(0.randomUpTo(1+self.dificultad()) < 1) 
			self.gritar()
		else 
			self.golpear() 
			
		// hay un 20% de chance de que cambie de dirección
		if(1.randomUpTo(10) > 8) {
			caminandoALaIzquierda = !caminandoALaIzquierda
		}
		
		detenido = false 
		game.schedule((1000 - (self.dificultad()*100).max(400)), { 
			
			if(!detenido){
				caminandoALaIzquierda = (not caminandoALaIzquierda and self.coordenadaActualX() >= 61) 
									or (caminandoALaIzquierda and self.coordenadaActualX() >25)
				const direccion = if(caminandoALaIzquierda) -1 else 1
				const nuevaPosicionX = self.coordenadaActualX() + distanciaEntreVentana * direccion
				self.caminarAPosicionXyEjecutar(nuevaPosicionX, {self.hacerRutina()})
			}
		})
	}
	method irAPosicionInicial(){
		self.position(new Position(x = 43, y = fila))
	}
	method finalizarRutina(){
		detenido = true
		self.quedarseParado()
		self.irAPosicionInicial()
	}
	


}
	
