import animacion.*
import elementos.*
import personaje.*
import juego.*
import pantalla.*
import wollok.game.*


object felix inherits Animado( position=new Position(x = 30, y = 2),
  							   velocidad = 30 ){
	
	var mirandoAlaDerecha = true
	var saltando = false
	var reparando = false
	
	//mientras felix está inmune los objetos no le hacen daño
	var inmune = false
	const sensores = []
	
	//referencia al stage actual
	var property stage = nullStage
	
	var invisible = false
	

	const  animacionParadoDerecha = new Animacion( 
										reproduccionContinua= false,
				  						velocidad=0,
  										fotogramas=["felix/derecha-parado.png"])
 
  
	const  animacionReparandoDerecha = new Animacion( 
										reproduccionContinua= false,
				  						velocidad=6,
  										fotogramas=["felix/derecha-parado.png",
  													"felix/derecha-saltando-1.png", 
  													"felix/derecha-golpeando.png",
  													"felix/derecha-parado.png"]
  								)
    const  animacionReparandoIzquierda = new Animacion( 
				  						velocidad=6,
				  						reproduccionContinua= false,
  										fotogramas=["felix/izquierda-parado.png",
  													"felix/izquierda-saltando-1.png", 
  													"felix/izquierda-golpeando.png",
  													"felix/izquierda-parado.png"]
  								)  

	const  animacionSaltandoIzquierda = new Animacion( 
				  						velocidad=10,
				  						reproduccionContinua= false,
  										fotogramas=["felix/izquierda-parado.png",
  													"felix/izquierda-saltando-1.png" 
  													]
  								)
  	const  animacionSaltandoDerecha = new Animacion( 
				  						velocidad=4,
				  						reproduccionContinua= false,
  										fotogramas=["felix/derecha-parado.png",
  													"felix/derecha-saltando-1.png" 
  													]
  								)

  	const  animacionCayendoDerecha = new Animacion( 
				  						velocidad=4,
				  						reproduccionContinua= false,
  										fotogramas=[
  													"felix/derecha-saltando-1.png",
  													"felix/derecha-parado.png"
  													]
  								)

  	const  animacionCayendoIzquierda = new Animacion( 
				  						velocidad=4,
				  						reproduccionContinua= false,
  										fotogramas=[
  													"felix/izquierda-saltando-1.png",
  													"felix/izquierda-parado.png"
  													]
  								)


	method initialize() {
		animacion = animacionParadoDerecha
		(1..4).forEach({ i => self.agregarSensor() })
		self.actualizarSensores()
		
	}
	

	override method image() {
		return if(invisible) "nada.png" else super()
	}

	method dificultad() = stage.dificultad()

	// la velocidad de felix depende el nivel
	override method velocidad() {
		return super() + self.dificultad() * 2
	}

	method saltando() = saltando
	method reparando() = reparando
  								
  	method reparar(ventana){
  		if(!saltando && !reparando) {
  			reparando = true
	  		self.detenerMovimiento()
			self.animar(self.animacionReparando())
			game.schedule(200,{
				if(ventana.salud() < 2) {
					score.sumarPuntos(50)				
				}
				ventana.reparar()
				reparando = false
				self.siguienteFotograma()
			})	 
			arreglar.reproducir() 			
  		}
  	}
  	
  	method animacionReparando() {
  		return if(mirandoAlaDerecha) animacionReparandoDerecha else animacionReparandoIzquierda
  	}
  	
  	method animacionSaltando() {
  		return if(mirandoAlaDerecha) animacionSaltandoDerecha else animacionSaltandoIzquierda
  	}
  	method animacionCayendo() {
  		return if(mirandoAlaDerecha) animacionCayendoDerecha else animacionCayendoIzquierda
  	}
  	
  	override method addVisual() {
  		super()
		game.whenCollideDo(self, { c => if(c.haceDanio()) self.perderVida()  }) 
		self.mostrarSensores()
		self.activarSensores()
  	}
  	
  	override method removeVisual() {
  		super()
  		self.ocultarSensores()
  	}

	/* agrega un nuevo sendor a felix */
	method agregarSensor() {
		sensores.add(new Sensor(position = new MutablePosition(x=position.x(), y=position.y())))
	}
  	
  	method mostrarSensores() {
		sensores.forEach({s => s.addVisual()})
  	}
  	method activarSensores() {
		sensores.forEach({s => s.activarDeteccion({ c => if(c.haceDanio()) self.perderVida()  })})
  	}
  	
  	method ocultarSensores() {
		sensores.forEach({s => s.removeVisual()})  		
  	}

	method actualizarSensores() {
		// apila los sensores arriba de la celda de felix
		(1..sensores.size()).forEach({ i => sensores.get(i-1).positionXY(position.x(), position.y()+i*2)	})
	}

  	
  	override method position(pos) {
  		super(pos)
  		self.actualizarSensores()
  	}

  	override method positionXY(x, y) {
  		super(x, y)
  		self.actualizarSensores()
  	}

  	
	method perderVida() {
  		if(!inmune) {
	  		inmune = true
	  		self.perderVida2()
	  		self.parpadear()
	  		game.schedule(3000, {
	  			inmune = false
				self.resetearAnimacion()		
	  		})
	  	
  	}}
  	
 	
  	method perderVida2(){ // cuando se queda sin vidas finaliza el juego. CAMBIARLO A JUEGO
  		if(vida.vidasActuales()>1){
	  		vida.perderVida()
	  		restarVida.reproducir()
  		} else {
  			juego.stageActual().finalizar()
  			gameOver.addVisual()
  			sgameOver.reproducir()
  		}
  	}
  	
  	// hace que felix aparezca y desaparezca mientras esté inmune (perdió una vida)
  	method parpadear() {
  		if(inmune) {
  			invisible = !invisible
	  		game.schedule(200, {
	  			self.parpadear()
	  		})
  		} else {
  			invisible = false
  		}
  	}

  	
  	override method moverAPosicionyHacerAccion(x,y, accion){
  		if(!saltando) {
	  		mirandoAlaDerecha = x >= self.coordenadaActualX()
	  		saltando = true
			self.animar(self.animacionSaltando())
	  		super(x,y, {
	  			self.actualizarSensores()
	  			self.animar(self.animacionCayendo())	  			
	  			saltando = false
	  			accion.apply()
	  		})  
	  	  	sonidoSalto.reproducir()
  		}
  	}
  	
  	override method detenerMovimiento() {
  		super()
  		saltando = false
  	}
  	
  	method reset() {
		self.resetearAnimacion()
		self.detenerMovimiento()
		self.actualizarSensores()
		mirandoAlaDerecha = true
		inmune = false 
		reparando = false
  	}
}
