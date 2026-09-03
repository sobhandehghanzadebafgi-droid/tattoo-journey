import { type NextRequest, NextResponse } from "next/server";
import { createServerClient } from "@supabase/ssr";
export async function middleware(request:NextRequest){
 let response=NextResponse.next({request});
 const supabase=createServerClient(process.env.NEXT_PUBLIC_SUPABASE_URL!,process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY!,{
  cookies:{getAll(){return request.cookies.getAll()},setAll(c){c.forEach(({name,value})=>request.cookies.set(name,value));response=NextResponse.next({request});c.forEach(({name,value,options})=>response.cookies.set(name,value,options))}
 }});
 const {data:{user}}=await supabase.auth.getUser();
 if(request.nextUrl.pathname.startsWith("/admin")&&!user)return NextResponse.redirect(new URL("/login",request.url));
 return response;
}
export const config={matcher:["/admin/:path*"]};