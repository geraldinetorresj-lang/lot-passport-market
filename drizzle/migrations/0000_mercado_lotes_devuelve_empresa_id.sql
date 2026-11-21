DROP FUNCTION IF EXISTS public.mercado_lotes();

CREATE OR REPLACE FUNCTION public.mercado_lotes()
 RETURNS TABLE(codigo text, categoria text, peso_kg numeric, distrito text, publicado_at timestamp with time zone, nombre_empresa text, foto_principal text, empresa_id uuid)
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  SELECT l.codigo, l.categoria, l.peso_kg, l.distrito, l.publicado_at, e.nombre_empresa,
    (SELECT f.ruta_storage FROM public.lote_fotos f WHERE f.lote_id = l.id ORDER BY f.orden, f.created_at LIMIT 1),
    l.empresa_id
  FROM public.lotes l JOIN public.empresas e ON e.id = l.empresa_id
  WHERE l.estado = 'publicado'
  ORDER BY l.publicado_at DESC NULLS LAST
  LIMIT 300;
$function$;

REVOKE ALL ON FUNCTION public.mercado_lotes() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.mercado_lotes() TO anon;
GRANT EXECUTE ON FUNCTION public.mercado_lotes() TO authenticated;
GRANT EXECUTE ON FUNCTION public.mercado_lotes() TO service_role;