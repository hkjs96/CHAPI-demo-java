package kr.co.futuresense.demoweb;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.IOUtils;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class HomeController {

	/*
	@RequestMapping("/")
	public String home(Locale locale, Model model) {
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		model.addAttribute("localeInfo", locale);
		model.addAttribute("serverTime", formattedDate);
		return "home";
	}
	*/
	
	@RequestMapping("/")
	public String home() {
		return "home";
	}
	
	@RequestMapping("/issuer")
	public String issuer() {
		return "issuer";
	}
	
	@RequestMapping("/wallet")
	public String wallet() {
		return "wallet";
	}
	
	@RequestMapping("/verifier")
	public String verifier() {
		return "verifier";
	}
	
	//
	//
	//
	
	@RequestMapping("wallet-worker")
	public String walletWorker() {
		return "wallet-worker";
	}
	
	@RequestMapping("wallet-ui-get")
	public String walletUiGet() {
		return "wallet-ui-get";
	}
	
	@RequestMapping("wallet-ui-store")
	public String walletUiStore() {
		return "wallet-ui-store";
	}
	
	//
	//
	//
	@PostMapping(value = "/createJws", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String createJws( HttpServletRequest req , Model model) {

		String data = null;
		try {
			data = IOUtils.toString(req.getReader());
			data = "";
			data = JWS.create(data);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return data;
	}
}
