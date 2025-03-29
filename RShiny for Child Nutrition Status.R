library(shiny)
library(shinythemes)
library(plotly)
library(readxl)
library(lubridate)
library(shinyMobile)

ui <- fluidPage(
  theme = shinytheme("united"),
  navbarPage("Status Gizi Balita Provinsi Jawa Timur:",
             
             tabPanel("Home",
                      sidebarPanel(
                        HTML("<h3>Input Parameter</h3>"),
                        textInput("nama", "Nama Anak", 
                                  value = "", 
                                  placeholder = "Masukkan nama anak"),
                        numericInput("height", "Tinggi (cm)", value = NULL, min = 40, max = 250, step = 0.1),
                        numericInput("weight", "Berat (kg)", value = NULL, min = 0, max = 50, step = 0.1),
                        selectInput("gender", "Jenis Kelamin", choices = list("Laki-Laki"="laki-laki", "Perempuan"="perempuan")),
                        dateInput("birthdate", "Tanggal Lahir", value = Sys.Date(), format = "dd-mm-yyyy"),
                        actionButton("submitbutton", "Submit", class = "btn btn-primary"),
                        
                        conditionalPanel(
                          condition = "input.submitbutton > 0",
                          hr(),
                          tags$div(style = "font-weight: bold; font-size: 22px; margin-bottom: 10px;", "Pilih Standar Gizi"),
                          radioButtons("standard", label = NULL, choices = list("Standar WHO-2006 (digunakan di Indonesia saat ini)" = "who", "Rancangan Standar Jawa Timur" = "lokal"))
                        )
                      ),
                      
                      mainPanel(
                        tags$label(h3('Hasil Status Gizi')),
                        verbatimTextOutput('contents'),
                        
                        uiOutput("statustb"),
                        uiOutput("statusbb"),
                        uiOutput("statusimunisasi"),
                        br(), br(),
                        
                        plotlyOutput("grafik_tb"),
                        br(), br(), 
                        plotlyOutput("grafik_bb")
                      )
             ),
             
             tabPanel("About", 
                      titlePanel("Tentang Aplikasi"),
                      
                      tags$head(
                        tags$style(HTML("
          .info-box {
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 2px 2px 10px rgba(0,0,0,0.1);
            background-color: #f9f9f9;
          }
        "))
                      ),
                      
                      fluidRow(
                        column(6,
                               div(class = "info-box",
                                   h3("Cara Menggunakan Aplikasi"),
                                   p("1. Masukkan nama anak, tinggi badan, berat badan, jenis kelamin, dan tanggal lahir."),
                                   p("2. Klik tombol 'Submit' untuk melihat hasil status gizi."),
                                   p("3. Pilih standar gizi yang digunakan: WHO-2006 atau Rancangan Standar Jawa Timur."),
                                   p("4. Hasil akan ditampilkan dalam bentuk teks dan grafik pertumbuhan.")
                               )
                        ),
                        column(6,
                               div(class = "info-box",
                                   h3("Standar WHO-2006"),
                                   p("Standar pertumbuhan WHO-2006 digunakan secara global untuk menilai status gizi anak berdasarkan tinggi dan berat badan."),
                                   p("Standar ini dibuat berdasarkan studi multi-negara dan merepresentasikan pola pertumbuhan anak yang sehat di berbagai lingkungan.")
                               )
                        )
                      ),
                      
                      fluidRow(
                        column(12,
                               div(class = "info-box",
                                   h3("Rancangan Standar Provinsi Jawa Timur"),
                                   p("Standar pertumbuhan ini disusun berdasarkan data anak-anak di Jawa Timur. Data ini menggambarkan pola pertumbuhan anak yang lebih spesifik sesuai dengan kondisi sosial dan ekonomi daerah."),
                                   p("Penggunaan standar ini dapat memberikan gambaran lebih akurat untuk evaluasi gizi di wilayah Jawa Timur.")
                               )
                        )
                      )
             ),
             
             tabPanel("Article", 
                      titlePanel("Artikel Kesehatan"),
                      
                      tags$head(
                        tags$style(HTML("
          .article-card {
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            box-shadow: 2px 2px 10px rgba(0,0,0,0.1);
            text-align: center;
          }
          .article-img {
            width: 100%;
            height: 150px;
            object-fit: cover;
            border-radius: 5px;
          }
        "))
                      ),
                      
                      fluidRow(
                        column(4,
                               div(class = "article-card",
                                   img(src = "https://sehatnegeriku.kemkes.go.id/wp-content/uploads/2018/04/IMG_20180407_112608.jpg", class = "article-img"),
                                   h4("Cegah Stunting dengan Perbaikan Pola Makan, Pola Asuh dan Sanitasi"),
                                   p("Terdapat tiga hal yang harus diperhatikan dalam pencegahan stunting, yaitu perbaikan terhadap pola makan, pola asuh, serta perbaikan sanitasi dan akses air bersih."),
                                   a("Baca selengkapnya", href = "https://sehatnegeriku.kemkes.go.id/baca/rilis-media/20180407/1825480/cegah-stunting-dengan-perbaikan-pola-makan-pola-asuh-dan-sanitasi-2/", target = "_blank")
                               )
                        ),
                        column(4,
                               div(class = "article-card",
                                   img(src = "https://rsupsoeradji.id/wp-content/uploads/2023/01/Bagaimana-Mengatasi-Berat-Badan-Kurang-pada-Anak.jpg", class = "article-img"),
                                   h4("Bagaimana Mengatasi Berat Badan Kurang pada Anak?"),
                                   p("Berat badan kurang atau underweight adalah kondisi saat berat badan anak berada di bawah rentang rata-rata atau normal. Idealnya, anak dikatakan memiliki berat badan normal ketika setara dengan teman-teman seusianya."),
                                   a("Baca selengkapnya", href = "https://rsupsoeradji.id/bagaimana-mengatasi-berat-badan-kurang-pada-anak/", target = "_blank")
                               )
                        ),
                        column(4,
                               div(class = "article-card",
                                   img(src = "https://ayosehat.kemkes.go.id/imagex/content/f183bf5ffabdd3e12dd872719581cb1c.png", class = "article-img"),
                                   h4("Ketahui Jadwal Imunisasi Dasar dan Manfaatnya"),
                                   p("Imunisasi dasar adalah pemberian vaksin untuk melindungi anak dari penyakit berbahaya sejak dini. Pemberian imuniasi dasar pada anak harus sesuai dengan jadwal yang telah ditentukan."),
                                   a("Baca selengkapnya", href = "https://ayosehat.kemkes.go.id/materi---poster-jadwal-imunisasi-dasar", target = "_blank")
                               )
                        )
                      )
             )
  )
)

server <- function(input, output) {
  rv <- reactiveValues()
  
  observeEvent(input$submitbutton, {
    rv$nama <- input$nama
    rv$tanggallahir <- as.Date(input$birthdate)
    rv$usia <- as.period(interval(rv$tanggallahir, Sys.Date()), unit = "month")$month
    rv$tinggi <- input$height
    rv$berat <- input$weight
    rv$gender <- input$gender
    rv$standard <- "who"  
  })
  
  observeEvent(input$standard, {
    rv$standard <- input$standard
  }, ignoreNULL = FALSE)
  
  output$contents <- renderText({
    req(rv$nama, rv$tinggi, rv$berat, rv$gender, rv$usia, rv$standard)
    standar_gizi <- ifelse(rv$standard == "who", "Standar WHO-2006", "Rancangan Standar Jawa Timur")
    
    sprintf("Nama: %s\nTinggi: %s cm\nBerat: %s kg\nJenis Kelamin: %s\nUsia: %s bulan\nStandar: %s", 
            rv$nama, rv$tinggi, rv$berat, rv$gender, rv$usia, standar_gizi)
  })
  
  output$statusimunisasi <- renderUI({
    req(rv$usia)
    
    usia_str <- as.character(rv$usia)
    
    style_status <- "background-color: #ECEFF1; color: black; padding: 5px; 
                   font-weight: bold; display: inline-block; border-radius: 5px; 
                   margin-bottom: 5px;"
    
    imunisasi_list <- list(
      "0"  = c("HB0"),
      "1"  = c("BCG", "OPV1"),
      "2"  = c("DPT-HB-Hib 1", "OPV2", "PCV1", "RV1*"),
      "3"  = c("DPT-HB-Hib 2", "OPV3", "PCV2", "RV2*"),
      "4"  = c("DPT-HB-Hib 3", "OPV4", "IPV1", "RV3*"),
      "9"  = c("Campak Rubela 1", "IPV2***"),
      "10" = c("JE**"),
      "12" = c("PCV3"),
      "18" = c("DPT-HB-Hib4", "Campak Rubela 2")
    )
    
    if (usia_str %in% names(imunisasi_list)) {
      imunisasi <- imunisasi_list[[usia_str]]
      
      imunisasi_ui <- lapply(imunisasi, function(vaksin) {
        div(style = style_status, vaksin)
      })
      
      div(style = "display: flex; align-items: center; gap: 10px; flex-wrap: wrap;", 
          tags$b("Status Imunisasi :"), do.call(tagList, imunisasi_ui))
      
    } else {
      div(style = "display: flex; align-items: center; gap: 10px;", 
          tags$b("Status Imunisasi :"), 
          div(style = style_status, "Tidak ada jadwal imunisasi tambahan"))
    }
  })
  
  output$grafik_tb <- renderPlotly({
    req(rv$usia, rv$tinggi, rv$standard, rv$gender)
    
    data_tb <- if (rv$gender == "laki-laki") {
      if (rv$standard == "who") datawholktb else datajatimlktb
    } else {
      if (rv$standard == "who") datawhoprtb else datajatimprtb
    }
    
    output$statustb <- renderUI({
      req(rv$usia, rv$tinggi)
      v_umur <- datawholktb[datawholktb$Month == rv$usia, ]
      tinggibadan <- rv$tinggi
      
      if (tinggibadan < v_umur$SD3neg) {
        div(style = "display: flex; align-items: center; gap: 10px;", 
            tags$b("Status Gizi TB/U :"), 
            div(style = "background-color: #FF6B6B; color: white; padding: 5px; font-weight: bold; display: inline-block; border-radius: 5px; margin-bottom: 5px;",
                "Sangat Pendek"))
      } else if (tinggibadan >= v_umur$SD3neg && tinggibadan < v_umur$SD2neg) {
        div(style = "display: flex; align-items: center; gap: 10px;", 
            tags$b("Status Gizi TB/U :"), 
            div(style = "background-color: #FFA726; color: white; padding: 5px; font-weight: bold; display: inline-block; border-radius: 5px; margin-bottom: 5px;",
                "Pendek"))
      } else if (tinggibadan >= v_umur$SD2neg && tinggibadan < v_umur$SD3) {
        div(style = "display: flex; align-items: center; gap: 10px;", 
            tags$b("Status Gizi TB/U :"), 
            div(style = "background-color: #66BB6A; color: white; padding: 5px; font-weight: bold; display: inline-block; border-radius: 5px; margin-bottom: 5px;", 
                "Normal"))
      } else {
        div(style = "display: flex; align-items: center; gap: 10px;", 
            tags$b("Status Gizi TB/U :"), 
            div(style = "background-color: #42A5F5; color: white; padding: 5px; font-weight: bold; display: inline-block; border-radius: 5px; margin-bottom: 5px;", 
                "Tinggi"))
      }
    })
    
    plot_ly(data = data_tb) %>%
      add_trace(x = ~Month, y = ~SD3, type = "scatter", mode = "lines", fill = "tozeroy", name = "+3 Sd", fillcolor = "#008000", line = list(color = "black")) %>%
      add_trace(x = ~Month, y = ~SD2, type = "scatter", mode = "lines", fill = "tozeroy", name = "+2 SD", fillcolor = "#008000",line = list(color = "black")) %>%
      add_trace(x = ~Month, y = ~SD1, type = "scatter", mode = "lines", fill = "tozeroy", name = "+1 SD", fillcolor = "#008000", line = list(color = "black")) %>%
      add_trace(x = ~Month, y = ~SD0, type = "scatter", mode = "lines", fill = "tozeroy", name = "0 SD", fillcolor = "#008000", line = list(color = "black")) %>%
      add_trace(x = ~Month, y = ~SD1neg, type = "scatter", mode = "lines", fill = "tozeroy", name = "-1 SD", fillcolor = "#008000", line = list(color = "black")) %>%
      add_trace(x = ~Month, y = ~SD2neg, type = "scatter", mode = "lines", fill = "tozeroy", name = "-2 SD", fillcolor = "#FFFF00",line = list(color = "black")) %>%
      add_trace(x = ~Month, y = ~SD3neg, type = "scatter", mode = "lines", fill = "tozeroy", name = "-3 SD", fillcolor = "white", line = list(color = "red")) %>%
      add_markers(x = rv$usia, y = rv$tinggi, color = I("blue"), name = rv$nama) %>%
      layout(
        title = "Grafik Tinggi Badan (TB/U)",
        xaxis = list(title = 'Umur (bulan)', gridcolor = "transparent"),
        yaxis = list(title = 'Berat Badan (kg)', gridcolor = "transparent")
      )
  })
  
  output$grafik_bb <- renderPlotly({
    req(rv$usia, rv$berat, rv$standard, rv$gender)
    
    data_bb <- if (rv$gender == "laki-laki") {
      if (rv$standard == "who") datawholkbb else datajatimlkbb
    } else {
      if (rv$standard == "who") datawhoprbb else datajatimprbb
    }
    
    output$statusbb <- renderUI({
      req(rv$usia, rv$berat)
      v_umur <- datawholkbb[datawholkbb$Month == rv$usia, ]
      beratbadan <- rv$berat
      
      if (beratbadan < v_umur$SD3neg) {
        div(style = "display: flex; align-items: center; gap: 10px;", 
            tags$b("Status Gizi BB/U :"), 
            div(style = "background-color: #FF6B6B; color: white; padding: 5px; font-weight: bold; display: inline-block; border-radius: 5px; margin-bottom: 5px;",
                "Berat Badan Sangat Kurang"))
      } else if (beratbadan >= v_umur$SD3neg && beratbadan < v_umur$SD2neg) {
        div(style = "display: flex; align-items: center; gap: 10px;", 
            tags$b("Status Gizi BB/U :"), 
            div(style = "background-color: #FFA726; color: white; padding: 5px; font-weight: bold; display: inline-block; border-radius: 5px; margin-bottom: 5px;",
                "Berat Badan Kurang"))
      } else if (beratbadan >= v_umur$SD2neg && beratbadan < v_umur$SD1) {
        div(style = "display: flex; align-items: center; gap: 10px;", 
            tags$b("Status Gizi BB/U :"), 
            div(style = "background-color: #66BB6A; color: white; padding: 5px; font-weight: bold; display: inline-block; border-radius: 5px; margin-bottom: 5px;", 
                "Normal"))
      } else {
        div(style = "display: flex; align-items: center; gap: 10px;", 
            tags$b("Status Gizi BB/U :"), 
            div(style = "background-color: #42A5F5; color: white; padding: 5px; font-weight: bold; display: inline-block; border-radius: 5px; margin-bottom: 5px;",
                "Risiko Berat Badan Lebih"))
      }
    })
    
    plot_ly(data = data_bb) %>%
      add_trace(x = ~Month, y = ~SD3, type = "scatter", mode = "lines", fill = "tozeroy", name = "+3 Sd", fillcolor = "#FFD700", line = list(color = "black")) %>%
      add_trace(x = ~Month, y = ~SD2, type = "scatter", mode = "lines", fill = "tozeroy", name = "+2 SD", fillcolor = "#FFD700",line = list(color = "black")) %>%
      add_trace(x = ~Month, y = ~SD1, type = "scatter", mode = "lines", fill = "tozeroy", name = "+1 SD", fillcolor = "#008000", line = list(color = "black")) %>%
      add_trace(x = ~Month, y = ~SD0, type = "scatter", mode = "lines", fill = "tozeroy", name = "0 SD", fillcolor = "#008000", line = list(color = "black")) %>%
      add_trace(x = ~Month, y = ~SD1neg, type = "scatter", mode = "lines", fill = "tozeroy", name = "-1 SD", fillcolor = "#008000", line = list(color = "black")) %>%
      add_trace(x = ~Month, y = ~SD2neg, type = "scatter", mode = "lines", fill = "tozeroy", name = "-2 SD", fillcolor = "#FFFF00",line = list(color = "black")) %>%
      add_trace(x = ~Month, y = ~SD3neg, type = "scatter", mode = "lines", fill = "tozeroy", name = "-3 SD", fillcolor = "white", line = list(color = "red")) %>%
      add_markers(x = rv$usia, y = rv$berat, color = I("blue"), name = rv$nama) %>%
      layout(
        title = "Grafik Berat Badan (BB/U)",
        xaxis = list(title = 'Umur (bulan)', gridcolor = "transparent"),
        yaxis = list(title = 'Berat Badan (kg)', gridcolor = "transparent")
      )
  })
}

shinyApp(ui,server)
