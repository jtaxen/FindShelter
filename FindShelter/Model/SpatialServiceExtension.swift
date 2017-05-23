//
//  SpatialServiceExtension.swift
//  FindShelter
//
//  Created by ÅF Jacob Taxén on 2017-05-23.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import CoreLocation

extension SpatialService {
	
	func convertUTMToLatLon(north y: Double, east X: Double) -> CLLocationCoordinate2D {
		
		let x = (X - falseEasting)/k0
		
		let phi1 = footpointLatitude(y)
		let t = tan(phi1)
		
		let eta2 = ( a - b ) * ( a + b ) / ( b * b ) * ( 1 + cos(2 * phi1)) / 2
		let gamma = t * ( 1 + eta2 )
		let nu = a / sqrt( 1 - e2 * ( 1 - cos(2 * phi1) ) / 2 )
		let beta = x / nu
		let beta2 = beta**2
		
		let P = -gamma / 2
		let Q = (gamma/24) * ( (5 + 3 * (t**2)) + ( eta2 - 4 * (eta2**2)) - 9 * (t**2) * eta2 )
		let r1 = ( 61 + 90 * (t**2) + 45 * (t**4))
		let r2 = ( 46 * eta2 - 3 * (eta2**2) + 100 * (eta2**3) + 88 * (eta2**4))
		let r3 = ( 252 * (t**2) * eta2 + 66 * (t**2) * (eta2**2) - 84 * (t**2) * (eta2**3) + 192 * (t**2) * (eta2**4) )
		let r4 = ( 90 * (t**4) * (eta2*2) - 225 * (t**4) * (eta2**2) )
		let R = ( -gamma/720) * ( r1 + r2 - r3 - r4 )
		let S = ( gamma / 40320 ) * (1385 + 3633 * (t**2) + 4095 * (t**4) + 1575 * (t**6))
		
		let T = ( -1/6 ) * ( 1 + 2 * (t**2) + eta2)
		let u1 = ( 5 + 28 * (t**2) + 24 * (t**4))
		let u2 = ( 6 * eta2 - 3 * (eta2**2) - 4 * (eta2**3))
		let u3 = ( 8 * (t**2) * eta2 + 4 * (t**2) * (eta2**2) + 24 * (t**2) * (eta2**3))
		
		let U = (1/120) * ( u1 + u2 + u3 )
		let V = (-1/5040) * ( 61 + (t**2) * ( 662 + (t**2) * ( 1320 + 720 * (t**2))))
		
		let phi = phi1 + beta2 * ( P + beta2 * ( Q + beta2 * ( R + S * beta2 )))
		let deltaLambda = (beta/cos(phi1)) * ( 1 + beta2 * ( T + beta2 * ( U + beta2 * V)))
		
		let lambda = longitudeFromDeltaLambda(deltaLambda, X)
		
		return CLLocationCoordinate2D(latitude: degree(phi), longitude: degree(lambda))
	}
	
	func meridionalArc(_ phi: Double) -> Double {
		
		let A = a * ( 1 + n * ( -1 + (n**2) * ( 5 * ( 1 - n) / 4 + (n**2) * ( 81 * ( 1 - n ) / 64 ))))
		let B = ( 3 * n * a / 2 ) * ( 1 + n * ( -1 + n * ( 7/8 + n * -7/8 + 55 * n / 64 )))
		let C = (15 * (n**2) * a / 16) * ( 1 + n * ( -1 + n * ( 3/4 - 3 * n / 4)))
		let D = (35 * (n**3) * a / 48 ) * ( 1 + n * ( -1 + 11 * n / 16))
		let E = (315 * (n**4) * a / 512) * (1 - n)
		
		return  k0 * ((A * phi - B * sin(2*phi) + C * sin(4*phi) - D * sin(6*phi) + E * sin(8*phi)))
	}
	
	func footpointLatitude(_ y: Double, accuracy: Double = 1e-8) -> Double {
		
		let c = b / ( a * a * A0 )
		
		var phi = c * y
		var M = meridionalArc(phi)
		
		while abs( M - y ) > accuracy {
			
			phi += c * ( y - M )
			M = meridionalArc(phi)
		}
		
		return phi
	}
	
	func longitudeFromDeltaLambda(_ deltaLambda: Double, _ x: Double) -> Double {
		
		if x < 500000 {
			return radian(midmeridian) - abs(deltaLambda)
		} else {
			return radian(midmeridian) + abs(deltaLambda)
		}
	}
}
