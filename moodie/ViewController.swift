//
//  ViewController.swift
//  moodie
//
//  Created by Maestro on 25/11/16.
//  Copyright © 2016 Maestro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    var preguntas : [Pregunta] = []
    var preguntaActual = 1
    //var puntuacionComediaActual = 0
    
    @IBOutlet weak var imgPregunta1: UIImageView!
    @IBOutlet weak var imgPregunta2: UIImageView!
    
    @IBAction func doTapImagen1(sender: AnyObject) {
        elegirOpcion(0)
    }
    
    @IBAction func doTapImagen2(sender: AnyObject) {
        elegirOpcion(1)
    }
    
    func elegirOpcion(eleccion : Int){
        
        preguntaActual+=1
        
        //puntuacionComediaActual += preguntas[((preguntaActual-1)*2)+eleccion].comedia!
        
        if preguntaActual <= 2 {
        imgPregunta1.stopAnimating()
        imgPregunta2.stopAnimating()
        
        imgPregunta1.animationImages = preguntas[(preguntaActual-1) * 2].imgFoto
        imgPregunta2.animationImages = preguntas[((preguntaActual-1) * 2)+1].imgFoto
        
        imgPregunta1.startAnimating()
        imgPregunta2.startAnimating()
        } else {
            // ir a la recomendacion
            performSegueWithIdentifier("goToRecomendacion", sender: self)
        }
        
    }
    
    // esto debe ser sacado del webservice
    var nombreImagenes = ["rusia", "dinamarca", "brazil", "estonia"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(.GET, "https://quehayobson.azurewebsites.net/api/get_posts/", parameters: ["post_type": "lugar"]) // le decimos que a ese sitio web le haga un GET... El parametro es un diccionario cuya llave es foo
            .responseJSON { response in // el in indica que lo que esta antes del mismo es un parametro para el siguiente bloque de codigo que se va a ejecutar
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization Ya en jSON
                
                if let diccionarioRespuesta = response.result.value as? NSDictionary{ // en result esta lo que te trajo esa llamada, y en este caso lo guardamos en una variables llamada json.
                    // lo anterior dice: si puedes convertir la respuesta en un nsdictionary.. entonces ponselo a diccionarioRespuesta y rifatela
                    /*  self.lblDireccion.text = String(diccionarioRespuesta.valueForKey("count_total") as! Int) // alamo fire esta consciente que la mayoria de las llamadas de HTTP son para mostrar informacion en pantalla... por lo tanto, a diferencia del otro metodo, no tenemos que agregar la funcion "dispatch".
                     // count total es un parametro en la respuesta del sitio al hacerle un get con el codigo 111*/
                    
                    if let posts = diccionarioRespuesta.valueForKey("posts") as? NSArray { // posts es un arreglo de posts, cada un es un objeto (que en swift llamamos NSDictionary)
                        
                        for post in posts {
                            if let diccionarioPost = post as? NSDictionary {
                                // aqui estas haciendo un casting de post a diccionario y se lo estas mandando al constructor Lugar
                                
                                self.preguntas.append(Pregunta(diccionario: diccionarioPost, callback: self.actualizarTableViewLugares)) // esta funcion no tiene parentesis porque no se esta ejecutando, sino que, la estamos mandando como parametro cuando se crea el Lugar
                            }
                        }
                        
                        self.tvLugares.reloadData() // vuelve a ejecutar todas las funciones del table view
                        
                    }
                }
        }
        
        
        for nombre in nombreImagenes{
            
            let tempPregunta = Pregunta()
            tempPregunta.accion =  1
            tempPregunta.cienciaFiccion = 2
            tempPregunta.comedia = 3
            tempPregunta.imagenes.append(UIImage(named: nombre)!) // en este caso va a ser happy.. sad.. angry.. surprise
            tempPregunta.imagenes.append(UIImage(named: "\(nombre)2")!)
            preguntas.append(tempPregunta)
            
        }
        
        imgPregunta1.animationImages = preguntas[0].imgFoto
        imgPregunta2.animationImages = preguntas[1].imagenes
        
        imgPregunta1.animationDuration = 1
        imgPregunta2.animationDuration = 1
        
        imgPregunta1.startAnimating()
        imgPregunta2.startAnimating()
        
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
}

