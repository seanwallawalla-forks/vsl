// Copyright (c) 2019 Ulises Jeremias Cornejo Fandos. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.

module vsl

import math

pub struct Quaternion {
pub:
	w f64
        x f64
        y f64
        z f64
}

pub fn quaternion(w, x, y, z f64) Quaternion {
        return Quaternion{w, x, y, z}
}

/**
 * Initializes the vector portion of the quaternion with 0.0 and the
 * scalar portion with 1.0.
 * The resulting quaternion has a norm of 1.0
 *
 * While CML as well as other math libraries call this the 'identity'
 * quaternion, this is not an accurate term.  Since the principle of a
 * quaternion with no rotation works similar to an identity matrix, we let
 * the term pass.
 *
 */
pub fn quaternion_id() Quaternion {
        return Quaternion{1.0, 0.0, 0.0, 0.0}
}

/**
 * Sets the values in the quaternion, in place, based on the axis and
 * angle.
 *
 * q = cos(angle/2) + i ( x * sin(angle/2)) + j (y * sin(angle/2)) + k ( z * sin(angle/2))
 *
 */
pub fn quaternion_from_axis_anglef3(angle, x, y, z f64) Quaternion {
        half_angle := angle / 2.0
        s := math.sin(half_angle)
        c := math.cos(half_angle)

        q := Quaternion{c, x * s, y * s, z * s}

        // reduce rounding errors caused by sin/cos
        return q.normalized()
}

pub fn quaternion_from_spherical_coords(theta, phi f64) Quaternion {
        half_theta := theta / 2.0
        half_phi := phi / 2.0

        ct := math.cos(half_theta)
        cp := math.cos(half_phi)
        st := math.sin(half_theta)
        sp := math.sin(half_phi)

        return Quaternion{cp * ct, -sp * st, st * cp, sp * ct}
}

pub fn quaternion_from_euler_angles(alpha, beta, gamma f64) Quaternion {
        half_alpha := alpha / 2.0
        half_beta := beta / 2.0
        half_gamma := gamma / 2.0

        ca := math.cos(half_alpha)
        cb := math.cos(half_beta)
        cc := math.cos(half_gamma)
        sa := math.sin(half_alpha)
        sb := math.sin(half_beta)
        sc := math.sin(half_gamma)

        return Quaternion{
                ca*cb*cc-sa*cb*sc,
                ca*sb*sc-sa*sb*cc,
                ca*sb*cc + sa*sb*sc,
                sa*cb*cc + ca*cb*sc
        }
}

pub fn (q Quaternion) copy() Quaternion {
        return Quaternion{q.w, q.x, q.y, q.z}
}

fn cof_str(a f64) string {
        return if a >= 0.0 { '+$a' } else { '$a' }
}

// To String method
// w + xi + yj + zk
pub fn (q Quaternion) str() string {
	mut out := '$q.w'
	out += cof_str(q.x)
        out += 'i'
        out += cof_str(q.y)
        out += 'j'
        out += cof_str(q.z)
        out += 'k'
	return out
}
