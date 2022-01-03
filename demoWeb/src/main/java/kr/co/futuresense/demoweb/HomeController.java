package kr.co.futuresense.demoweb;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

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
}
