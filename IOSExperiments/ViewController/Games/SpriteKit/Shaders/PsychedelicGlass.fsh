float iTime = u_time;
//vec2 iResolution = u_sprite_size;

vec2 uv;
vec2 pos;

float hash1( float n ) { return fract(sin(n)*43758.5453); }
vec2  hash2( vec2  p ) { p = vec2( dot(p,vec2(127.1,311.7)), dot(p,vec2(269.5,183.3)) ); return fract(sin(p)*43758.5453); }

vec2 rotate(vec2 p, float a) {
    float cs = cos(a), sn = sin(a);
    return (mat3(
                 cs, sn, 0.0,
                 -sn, cs, 0.0,
                 0.0, 0.0, 1.0) * vec3(p,1.0)).xy;
}

// ratio: 3 = neon, 4 = refracted, 5+ = approximate white
vec3 physhue2rgb(float hue, float ratio) {
    return smoothstep(
                      vec3(0.0),vec3(1.0),
                      abs(mod(hue + vec3(0.0,1.0,2.0)*(1.0/ratio),1.0)*2.0-1.0));
}

vec4 voronoi( in vec2 x, float c, out vec2 rp)
{
    vec2 n = floor( x );
    vec2 f = fract( x );
    
    vec3 m = vec3( 8.0 );
    float m2 = 8.0;
    for( int j=-2; j<=2; j++ )
        for( int i=-2; i<=2; i++ )
        {
            vec2 g = vec2( float(i),float(j) );
            vec2 o = hash2( n + g );
            
            // animate
            float cid = hash1( dot(n+g,vec2(7.0,113.0) ) );
            if (cid < 0.1)
                o = 0.5 + 0.5*abs(mod(c + o,2.0)-1.0);
            
            vec2 r = g - f + o;
            
            // triangular
            vec2 d = vec2( max(abs(r.x)*0.866025+r.y*0.5,-r.y),
                          1.0 );
            
            
            if( d.x<m.x )
            {
                m2 = m.x;
                m.x = d.x;
                m.y = cid;
                m.z = d.y;
                rp = n + g;
            }
            else if( d.x<m2 )
            {
                m2 = d.x;
            }
            
        }
    return vec4( m, m2-m.x );
}

vec4 render_sheet(vec2 p, float fi, float a) {
    
    float z = exp(mix(log(32.0), log(0.5), a));
    
    //p.y = abs(p.y);
    p.y = -p.y;
    float tpos = abs(p.x); //max(abs(p.x)*0.866025-p.y*0.5,p.y);
    p.x = abs(p.x);
    p = rotate(p, radians(60.0));
    p.x = abs(p.x);
    
    //p = rotate(p, radians(-60.0));
    //p.x = abs(p.x);
    
    vec2 rp;
    float o = fi*128.0-step(fi,0.2)*a*2.0;
    vec4 c = voronoi( z*p+o, fi+a*8.0, rp);
    rp -= o;
    
    float pp = 0.6 - (max(abs(rp.x)*0.866025+rp.y*0.5,-rp.y)/4.0); // + fract(fi+c.y);
    pp = clamp(pp, 0.0, 1.0);
    
    float fadein = clamp(a*2.0,0.0,1.0);
    
    float rep = 1.0-a-(pp-sin(c.w*40.0)*0.1)*fadein;//;
    
    float alpha = clamp((rep-c.w)*16.0, 0.0, 1.0);
    if (alpha > 0.0) {
        float hue = c.w*(1.0+c.y*8.0)
        +fi+a*9.0*c.y*mix(1.0,8.0,step(fi,0.1))
        -tpos*1.0;
        
        vec3 w = physhue2rgb(hue, 4.0);
        w.z = 0.5; //sin(iTime)*0.1+0.5;
        return vec4(w, alpha);
    }
    
    return vec4(0.0);
}

vec4 alpha(vec4 a, vec4 b) {
    a = mix(b, a, a.w);
    a.w = max(a.w, b.w);
    return a;
}

#define STEPS 6

void mainImage( out vec4 fragColor, in vec2 uv )
{
    vec2 aspect = vec2(1.0, 1.0);
//    vec2 aspect = vec2(iResolution.x / iResolution.y, 1.0);
//    vec2 uv = fragCoord.xy / iResolution.xy;
    vec2 pos = (uv*2.0-1.0)*aspect;
    
    vec4 col = vec4(0.0);
    
    float s = 1.0/float(STEPS);
    
    float t = iTime*0.5;
    float a = fract(t)*s;
    t -= fract(t);
    
    for (int i = STEPS-1; i >= 0; --i) {
        float fi = float(i);
        col = alpha(col, render_sheet(pos, hash1(t-fi), a+fi*s));
        if (col.w >= 1.0) break;
    }
    
    float blend = sin(iTime)*0.5+0.5;
    blend = 0.2; //smoothstep(0.0,1.0,blend);
    
    vec3 co = texture2D(u_texture, uv + col.xy*blend*0.1).rgb;
    col.rgb = mix(co, col.rgb, blend);
    
    fragColor = col;
}

void main() {
    mainImage(gl_FragColor,v_tex_coord.xy);
}
