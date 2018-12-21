// Created by inigo quilez - iq/2013
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

// triangulation .. attempt to simulate broken glass!

//#define t iTime

float fx=fract(1.+0.5);  // broke factor !

mat4 setRotation( float x, float y, float z )
{
    float a = sin(x); float b = cos(x);
    float c = sin(y); float d = cos(y);
    float e = sin(z); float f = cos(z);

    float ac = a*c;
    float bc = b*c;

    return mat4( d*f,      d*e,       -c, 0.0,
                ac*f-b*e, ac*e+b*f, a*d, 0.0,
                bc*f+a*e, bc*e-a*f, b*d, 0.0,
                0.0,      0.0,      0.0, 1.0 );
}

mat4 setTranslation( float x, float y, float z )
{
    return mat4( 1.0, 0.0, 0.0, 0.0,
                0.0, 1.0, 0.0, 0.0,
                0.0, 0.0, 1.0, 0.0,
                x,     y,   z, 1.0 );
}

struct Vertex
{
    vec3  pos;
    vec2  uv;
    float occ;
};


struct Triangle
{
    Vertex a;
    Vertex b;
    Vertex c;
    vec3 n;
};


vec4 func( in vec2 s )
{



    float r = 1.0 + fx*cos(16.0*s.x + 6.28318*s.y + fx );

    return vec4( r*vec3(s.y,s.x,0.0 ), 1.0 );

    // broken now !!
}


Triangle calcTriangle( float u, float v, float du, float dv, int k )
{


    vec2 aUV = vec2( u,    v    );
    vec2 bUV = vec2( u+du, v+dv );
    vec2 cUV = vec2( u+du, v    );
    vec2 dUV = vec2( u,    v+dv );

    if( k==1 )
    {
        cUV = bUV;
        bUV = dUV;
    }



    vec4 a = func( aUV );
    vec4 b = func( bUV );
    vec4 c = func( cUV );
    vec3 n = normalize( -cross(c.xyz-a.xyz, b.xyz-a.xyz));

    return Triangle( Vertex(a.xyz, 1.0*aUV, a.w),
                    Vertex(b.xyz, 1.0*bUV, b.w),
                    Vertex(c.xyz, 1.0*cUV, c.w), n);
}

vec3 lig = normalize( vec3( 0.0,0.0,0.0) );

vec3 pixelShader( in vec3 nor, in float oc, in vec2 uv, vec3 di )
{

    float wire = 1.0 - smoothstep( 0.0, 0.02, di.x ) *
    smoothstep( 0.0, 0.02, di.y ) *
    smoothstep( 0.0, 0.02, di.z );

    vec3 material = texture2D(u_texture, uv ).xyz;

    material += 2.*wire * vec3(0.2,0.2,0.2);


    return   material ;
}

float crosss( vec2 a, vec2 b )
{
    return a.x*b.y - a.y*b.x;
}

void mainImage( out vec4 fragColor, in vec2 px )
{

    mat4 mdv = setTranslation( 0.0, 1.0, -2.0 ) *
    setRotation( 0.0, 0., -1.57 )  ;

//    vec2 px = fragCoord / iResolution.xy;

    px.y =1.-px.y;

    //  px.x *= iResolution.x/iResolution.y;
    // vertex points ;     a ,b,c
    float aa = fx/10.;
    float bb = 0.00;
    float cc = 0.00;

    vec3 color = vec3( 0.0 );

    // clear zbuffer
    float mindist = -1000000.0;

    // for every triangle
    float du = 1.0/8.0;
    float dv = 1.0/8.0;
    for( int k=0; k< 2; k++ )
        for( int j=0; j<8; j++ )
            for( int i=0; i<8; i++ )
                //for( int i=0; i<100; i++ )
            {
                // get the triangle
                float pu = float(i)*du;
                float pv = float(j)*dv;



                Triangle tri = calcTriangle( pu, pv, du, dv, k );

                // transform to eye space
                vec3 ep0 = (mdv * vec4(tri.a.pos-aa,1.0)).xyz;
                vec3 ep1 = (mdv * vec4(tri.b.pos+bb,1.0)).xyz;
                vec3 ep2 = (mdv * vec4(tri.c.pos-cc,1.0)).xyz;
                vec3 nor = (mdv * vec4(tri.n,0.0)).xyz;

                // transform to clip space
                float w0 = 1.0/ep0.z;
                float w1 = 1.0/ep1.z;
                float w2 = 1.0/ep2.z;

                vec2 cp0 = 2.0*ep0.xy * -w0;
                vec2 cp1 = 2.0*ep1.xy * -w1;
                vec2 cp2 = 2.0*ep2.xy * -w2;

                {

                    // fetch vertex attributes, and divide by z
                    vec2  u0 = tri.a.uv  * w0;
                    vec2  u1 = tri.b.uv  * w1;
                    vec2  u2 = tri.c.uv  * w2;
                    float a0 = tri.a.occ * w0;
                    float a1 = tri.b.occ * w1;
                    float a2 = tri.c.occ * w2;


                    // calculate areas for subtriangles
                    vec3 di = vec3( crosss( cp1 - cp0, px - cp0 ),
                                   crosss( cp2 - cp1, px - cp1 ),
                                   crosss( cp0 - cp2, px - cp2 ));

                    // if all positive, point is inside triangle
                    if( all(greaterThan(di,vec3(0.0,0.0,0.0))) )
                    {
                        // calc barycentric coordinates
                        vec3 ba = di.yzx / (di.x+di.y+di.z);


                        // barycentric interpolation of attributes and 1/z
                        float iz = ba.x*w0 + ba.y*w1 + ba.z*w2;
                        vec2  uv = ba.x*u0 + ba.y*u1 + ba.z*u2;
                        float oc = ba.x*a0 + ba.y*a1 + ba.z*a2;

                        // recover interpolated attributes (this could be done after 1/depth test)
                        float z = 1.0/iz;
                        uv *= z;
                        oc *= z;

                        // depth buffer test
                        if( z>mindist )
                        {
                            mindist = z;

                            // run pixel shader
                            color = pixelShader( nor, oc, uv, ba );
                        }
                    }
                }
            }

    fragColor = vec4(color,1.0);
}


//vec4 mainImage(vec2 uv, float iTime) {
//    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));
//    return vec4(col,1.0);
//}

// https://www.shadertoy.com/view/Xl3Szr
void main() {
    mainImage(gl_FragColor,v_tex_coord.xy);
}
